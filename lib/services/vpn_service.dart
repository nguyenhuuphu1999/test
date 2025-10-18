// services/vpn_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../features/keys/domain/entities/key.dart' as KeyEntity;
import 'outline_brigde.dart';

/// VpnService phiên bản "đi như hình":
/// - connectWithKey: mở proxy local qua Shadowsocks, tạo IOClient qua proxy,
///   áp dụng proxy cho WebView và khởi động VPN TUN để toàn bộ traffic đi qua
/// - disconnect: dừng VPN, clear WebView proxy và stop proxy local
class VpnService {
  static final VpnService _instance = VpnService._internal();
  factory VpnService() => _instance;
  VpnService._internal();

  // ======= Trạng thái =======
  final ValueNotifier<String> _statusNotifier = ValueNotifier<String>(
    'disconnected',
  );
  String _currentStatus = 'disconnected';
  KeyEntity.Key? _connectedKey;

  // Proxy state
  String? _proxyAddress; // "127.0.0.1:<port>"
  IOClient? _ioClientProxy; // HTTP client đi qua proxy

  // ======= Getters giữ API cũ =======
  String get currentStatus => _currentStatus;
  ValueNotifier<String> get statusNotifier => _statusNotifier;
  KeyEntity.Key? get connectedKey => _connectedKey;
  bool get isConnected => _currentStatus == 'connected';
  String get connectionStatus => _currentStatus;
  String? get connectedKeyName => _connectedKey?.name;
  String? get connectedServer => _connectedKey?.serverName;

  /// Giữ tương thích: coi như key hiện tại là key đang nối
  bool isKeyConnected(KeyEntity.Key key) {
    if (!isConnected || _connectedKey == null) return false;
    // so sánh theo id nếu có, fallback theo name+server+port
    if (_connectedKey!.id != null && key.id != null) {
      return _connectedKey!.id == key.id;
    }
    return _connectedKey!.name == key.name &&
        _connectedKey!.serverName == key.serverName &&
        _connectedKey!.port == key.port;
  }

  /// Initialize: không cần native init nào cho flow này,
  /// nhưng giữ hàm cho tương thích (no-op).
  Future<void> initialize() async {
    // no-op
  }

  /// Kết nối: mở proxy nội bộ bằng MobileProxy (OutlineBridge),
  /// tạo HTTP client qua proxy, (Android) áp dụng proxy cho WebView.
  Future<bool> connectWithKey(KeyEntity.Key key) async {
    try {
      debugPrint('🚀 Starting proxy (MobileProxy) for key: ${key.name}');

      final permissionOk = await OutlineBridge.ensureVpnPermission();
      if (!permissionOk) {
        throw Exception('VPN permission not granted');
      }

      // 1) Start local proxy using key configuration (Shadowsocks)
      final res = await OutlineBridge.startProxyForKey(
        key,
        port: 0,
        bindHost: '127.0.0.1',
      );

      if (!res.ok || res.address == null) {
        throw Exception('Start local proxy failed: ${res.error}');
      }

      _proxyAddress = res.address;
      debugPrint('✅ Local proxy at $_proxyAddress');

      // 2) Tạo IOClient đi qua proxy cho các request HTTP trong app
      _ioClientProxy?.close();
      _ioClientProxy = await OutlineBridge.createHttpClientViaProxy(
        _proxyAddress!,
      );

      // 3) (Android) Áp dụng proxy cho tất cả WebView trong app
      await OutlineBridge.applyWebViewProxy(_proxyAddress!);

      // 4) Khởi động VPN TUN để toàn bộ traffic đi qua Shadowsocks
      final vpnStarted = await OutlineBridge.startVpnTunnel(
        socksUpstream: _proxyAddress!,
        config: res.config ?? OutlineBridge.buildConfigForKey(key),
        port: res.port?.toString() ?? '1080',
        perApp: false,
        keyId: key.id?.toString(),
        keyName: key.name.isNotEmpty ? key.name : null,
      );

      if (!vpnStarted) {
        throw Exception('Failed to start VPN tunnel');
      }

      // 5) Mark connected
      _connectedKey = key;
      _setStatus('connected');

      // (tuỳ chọn) lưu thông tin key đã nối
      await _saveConnectedKeyMeta(key);

      return true;
    } catch (e) {
      debugPrint('❌ connectWithKey error: $e');
      try {
        await OutlineBridge.stopVpnTunnel();
      } catch (_) {}
      try {
        await OutlineBridge.clearWebViewProxy();
      } catch (_) {}
      try {
        await OutlineBridge.stopLocalProxy();
      } catch (_) {}
      await _forceCleanup();
      rethrow; // để UI hiện thông báo từ nơi gọi
    }
  }

  /// Ngắt kết nối: clear WebView proxy + stop local proxy.
  Future<void> disconnect() async {
    try {
      debugPrint('🛑 Disconnecting (proxy) ...');
      await OutlineBridge.stopVpnTunnel();
      await OutlineBridge.clearWebViewProxy();
      await OutlineBridge.stopLocalProxy();
    } catch (e) {
      debugPrint('⚠️ stopLocalProxy/clearWebViewProxy error: $e');
    } finally {
      await _forceCleanup();
      await _clearConnectedKeyPrefs();
      debugPrint('✅ Disconnected (proxy cleaned)');
    }
  }

  /// Test traffic qua proxy: gọi ipify qua IOClient đang dùng proxy.
  Future<bool> testVpnTrafficVerification() async {
    try {
      if (!isConnected || _proxyAddress == null) {
        debugPrint('❌ Not connected / no proxy address');
        return false;
      }
      final client =
          _ioClientProxy ??
          await OutlineBridge.createHttpClientViaProxy(_proxyAddress!);
      final resp = await client.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (resp.statusCode == 200) {
        final ip = json.decode(resp.body)['ip'];
        debugPrint('✅ Proxy traffic OK, public IP: $ip');
        return true;
      } else {
        debugPrint('❌ Proxy test HTTP ${resp.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Proxy traffic test error: $e');
      return false;
    }
  }

  /// Load connected key info (giữ API cũ): trả về key hiện tại nếu đang nối.
  Future<KeyEntity.Key?> loadConnectedKeyInfo() async {
    return _connectedKey;
  }

  // ================= Helpers =================
  void _setStatus(String s) {
    _currentStatus = s;
    _statusNotifier.value = s;
  }

  Future<void> _forceCleanup() async {
    try {
      _ioClientProxy?.close();
    } catch (_) {}
    _ioClientProxy = null;
    _proxyAddress = null;
    _connectedKey = null;
    _setStatus('disconnected');
  }

  Future<void> _saveConnectedKeyMeta(KeyEntity.Key key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('connected_key_name', key.name);
      await prefs.setString('connected_key_server', key.serverName);
      await prefs.setInt('connected_key_port', key.port);
      await prefs.setString('connected_key_method', key.method);
    } catch (e) {
      debugPrint('⚠️ Save connected key meta failed: $e');
    }
  }

  Future<void> _clearConnectedKeyPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('connected_key_name');
      await prefs.remove('connected_key_server');
      await prefs.remove('connected_key_port');
      await prefs.remove('connected_key_method');
    } catch (e) {
      debugPrint('⚠️ Clear connected key prefs failed: $e');
    }
  }
}
