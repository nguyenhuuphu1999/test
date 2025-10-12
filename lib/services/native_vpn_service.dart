import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ss_conf.dart';
import '../utils/v2ray_config.dart';
import '../features/keys/domain/entities/key.dart' as KeyEntity;
import 'keys_service.dart';

/// Native VPN Service using platform channels for real VPN connection
class NativeVpnService {
  static const MethodChannel _channel = MethodChannel('vpncn2/vpn_service');
  static const EventChannel _statusChannel = EventChannel('vpncn2/vpn_status');

  static final NativeVpnService _instance = NativeVpnService._internal();
  factory NativeVpnService() => _instance;
  NativeVpnService._internal();

  final ValueNotifier<String> _statusNotifier = ValueNotifier<String>(
    'disconnected',
  );
  KeyEntity.Key? _connectedKey;

  // Getters
  ValueNotifier<String> get statusNotifier => _statusNotifier;
  KeyEntity.Key? get connectedKey => _connectedKey;
  bool get isConnected => _statusNotifier.value == 'connected';

  /// Initialize native VPN service
  Future<void> initialize() async {
    try {
      debugPrint('🔧 Initializing Native VPN Service...');

      // Set up status listener
      _statusChannel.receiveBroadcastStream().listen(
        (status) {
          debugPrint('📡 VPN Status update: $status');
          _statusNotifier.value = status.toString();

          if (status == 'disconnected') {
            _connectedKey = null;
            _clearConnectedKey();
          }
        },
        onError: (error) {
          debugPrint('❌ VPN Status error: $error');
          _statusNotifier.value = 'error';
        },
      );

      // Initialize native VPN service
      await _channel.invokeMethod('initialize');
      debugPrint('✅ Native VPN Service initialized');
    } catch (e) {
      debugPrint('❌ Native VPN Service initialization failed: $e');
      rethrow;
    }
  }

  /// Connect to VPN using a specific key
  Future<bool> connectWithKey(KeyEntity.Key key) async {
    try {
      debugPrint('🔧 Native VPN: Connecting with key ${key.name}');

      // Stop current connection if any
      if (isConnected) {
        await disconnect();
      }

      // Create Shadowsocks config from key data
      final ssConfig = await _createSsConfigFromKey(key);
      final config = buildXrayConfigFromSs(ssConfig);

      debugPrint('📄 VPN Config: ${config.substring(0, 100)}...');

      // Request VPN permission
      final granted = await _requestVpnPermission();
      if (!granted) {
        throw Exception('Bạn đã từ chối quyền VPN');
      }

      // Start VPN connection
      final result = await _channel.invokeMethod('startVpn', {
        'remark': key.name,
        'config': config,
        'keyId': key.id,
      });

      if (result == true) {
        _connectedKey = key;
        _statusNotifier.value = 'connected';
        await _saveConnectedKey(key);
        debugPrint('✅ Native VPN: Connection successful');
        return true;
      } else {
        debugPrint('❌ Native VPN: Connection failed');
        // Ensure we're disconnected on failure
        _statusNotifier.value = 'disconnected';
        _connectedKey = null;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Native VPN: Connection error: $e');
      // Ensure we're disconnected on error
      _statusNotifier.value = 'error';
      _connectedKey = null;
      return false;
    }
  }

  /// Disconnect VPN
  Future<void> disconnect() async {
    try {
      debugPrint('🔧 Native VPN: Disconnecting...');

      await _channel.invokeMethod('stopVpn');

      _statusNotifier.value = 'disconnected';
      _connectedKey = null;
      await _clearConnectedKey();
      debugPrint('✅ Native VPN: Disconnected');
    } catch (e) {
      debugPrint('⚠️ Native VPN: Disconnect error: $e');
      // Still update status even if disconnect fails
      _statusNotifier.value = 'disconnected';
      _connectedKey = null;
    }
  }

  /// Request VPN permission
  Future<bool> _requestVpnPermission() async {
    try {
      final result = await _channel.invokeMethod('requestPermission');
      return result == true;
    } catch (e) {
      debugPrint('❌ VPN Permission request failed: $e');
      return false;
    }
  }

  /// Create Shadowsocks config from key data
  Future<SsConf> _createSsConfigFromKey(KeyEntity.Key key) async {
    String server;

    if (key.accessUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(key.accessUrl);
        server = uri.host;
      } catch (e) {
        server = key.serverName.isNotEmpty
            ? key.serverName
            : 'server.vpncn2.net';
      }
    } else {
      server = key.serverName.isNotEmpty ? key.serverName : 'server.vpncn2.net';
    }

    return SsConf(
      server: server,
      serverPort: key.port,
      password: key.password,
      method: key.method,
      prefix: null,
    );
  }

  /// Save connected key info
  Future<void> _saveConnectedKey(KeyEntity.Key key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('connected_key_id', key.id);
    debugPrint('💾 Native VPN: Saved connected key ID: ${key.id}');
  }

  /// Clear connected key info
  Future<void> _clearConnectedKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('connected_key_id');
    debugPrint('🗑️ Native VPN: Cleared connected key info');
  }

  /// Load previously connected key info from API
  Future<KeyEntity.Key?> loadConnectedKeyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final keyId = prefs.getString('connected_key_id');

    if (keyId != null) {
      try {
        debugPrint('🔍 Native VPN: Loading connected key info for ID: $keyId');

        // Use KeysService directly
        final result = await KeysService.getKeys(status: 1, pageSize: 100);

        return result.when(
          ok: (keys) {
            final connectedKey = keys.firstWhere(
              (key) => key.id == keyId,
              orElse: () => throw Exception('Key not found'),
            );

            debugPrint(
              '✅ Native VPN: Found connected key: ${connectedKey.name}',
            );
            return connectedKey;
          },
          err: (failure) {
            debugPrint('❌ Native VPN: Failed to load keys: ${failure.message}');
            return null;
          },
        );
      } catch (e) {
        debugPrint('❌ Native VPN: Error loading connected key: $e');
        return null;
      }
    }

    return null;
  }

  /// Check if a specific key is currently connected
  bool isKeyConnected(KeyEntity.Key key) {
    return _connectedKey?.id == key.id && isConnected;
  }

  /// Get connection status for UI
  String getConnectionStatusText() {
    switch (_statusNotifier.value) {
      case 'connected':
        return 'Đã kết nối';
      case 'connecting':
        return 'Đang kết nối...';
      case 'disconnected':
        return 'Chưa kết nối';
      case 'error':
        return 'Lỗi kết nối';
      default:
        return 'Không xác định';
    }
  }
}
