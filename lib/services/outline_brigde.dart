// lib/services/outline_brigde.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../features/keys/domain/entities/key.dart' as KeyEntity;

class StartProxyResult {
  final bool ok;
  final String? address;
  final String? host;
  final int? port;
  final String? error;
  final String? config; // ss:// config string actually used for the proxy
  StartProxyResult({
    required this.ok,
    this.address,
    this.host,
    this.port,
    this.error,
    this.config,
  });
}

class OutlineBridge {
  static const _sdkCh = MethodChannel(
    'outline_sdk',
  ); // start/stop proxy (native)
  static const _wvCh = MethodChannel(
    'webview_proxy',
  ); // set/clear WebView proxy
  static const _vpnCh = MethodChannel('vpncn2/vpn_service');

  // Giữ nguyên nếu bạn đang dùng WebView proxy:
  static Future<void> applyWebViewProxy(String address) async {
    if (kIsWeb) return; // no-op on web
    await _wvCh.invokeMethod('setWebViewProxy', {"address": address});
  }

  static Future<void> clearWebViewProxy() async {
    if (kIsWeb) return; // no-op on web
    await _wvCh.invokeMethod('clearWebViewProxy');
  }

  static Future<bool> ensureVpnPermission() async {
    if (kIsWeb) return true; // web has no VPN permission flow
    final ok = await _vpnCh.invokeMethod<bool>('requestPermission');
    return ok == true;
  }

  /// Dùng sẵn JSON lấy từ ssconf để tạo ss:// key (legacy)
  static String _buildLegacySsKey({
    required String host,
    required int port,
    required String method,
    required String password,
    String? remarks,
    String?
    prefixUtf8, // nếu có 'prefix' trong JSON, có thể giữ lại dưới dạng query
  }) {
    final credB64 = base64Encode(
      utf8.encode('$method:$password'),
    ).replaceAll('\n', '');
    final tag = (remarks == null || remarks.isEmpty)
        ? ''
        : '#${Uri.encodeComponent(remarks)}';

    // Thêm ?prefix= nếu bạn muốn gửi prefix xuống SDK (nhiều build của Outline SDK hỗ trợ query này)
    final query = (prefixUtf8 != null && prefixUtf8.isNotEmpty)
        ? '?prefix=${Uri.encodeComponent(prefixUtf8)}'
        : '';

    return 'ss://$credB64@$host:$port$query$tag';
  }

  static Future<StartProxyResult> _startLocalProxyWithConfig(
    String config, {
    int port = 0,
    String bindHost = '127.0.0.1',
  }) async {
    try {
      final res = await _sdkCh.invokeMapMethod<String, dynamic>(
        'startLocalProxy',
        {
          "preferSmart": false,
          "config": config,
          "bindHost": bindHost,
          "port": port,
        },
      );

      if (res == null || res['success'] != true) {
        return StartProxyResult(
          ok: false,
          error: res?['error']?.toString() ?? 'Unknown error',
          config: config,
        );
      }

      return StartProxyResult(
        ok: true,
        address: res['address']?.toString(),
        host: res['host']?.toString(),
        port: (res['port'] is int)
            ? res['port'] as int
            : int.tryParse(res['port']?.toString() ?? ''),
        config: config,
      );
    } catch (e) {
      debugPrint('❌ Error starting local proxy: $e');
      return StartProxyResult(ok: false, error: e.toString(), config: config);
    }
  }

  /// Đọc ssconf://.../https://... → fetch JSON → tạo ss://... → start local proxy
  static Future<StartProxyResult> startFromSsconfUrl(
    String ssconfUrl, {
    int port = 0, // 0 = cho hệ thống chọn cổng rảnh
    String bindHost = '127.0.0.1',
    String? remarks,
  }) async {
    try {
      // 1) Chuẩn hoá URL: ssconf://host/path.json → https://host/path.json
      final u = Uri.parse(ssconfUrl);
      final httpUri = (u.scheme == 'ssconf') ? u.replace(scheme: 'https') : u;

      // 2) Tải JSON
      final resp = await http.get(httpUri);
      if (resp.statusCode != 200) {
        return StartProxyResult(
          ok: false,
          error: 'Fetch ssconf failed: HTTP ${resp.statusCode}',
        );
      }
      final j = json.decode(resp.body) as Map<String, dynamic>;

      final server = (j['server'] ?? '').toString();
      final serverPort = int.tryParse(j['server_port'].toString()) ?? 0;
      final method = (j['method'] ?? '').toString();
      final password = (j['password'] ?? '').toString();
      final prefixBytes = (j['prefix'] as String?)
          ?.toString(); // ví dụ: "\u0016\u0003\u0001\u0000¨\u0001\u0001"

      if (server.isEmpty ||
          serverPort == 0 ||
          method.isEmpty ||
          password.isEmpty) {
        return StartProxyResult(ok: false, error: 'Invalid ssconf JSON');
      }

      // 3) Build ss:// key
      final ssKey = _buildLegacySsKey(
        host: server,
        port: serverPort,
        method: method,
        password: password,
        remarks: remarks,
        // Nếu muốn chuyển nguyên chuỗi prefix UTF-8 xuống Outline SDK (nhiều bản SDK hiểu query ?prefix=)
        prefixUtf8: prefixBytes,
      );

      return await _startLocalProxyWithConfig(
        ssKey,
        port: port,
        bindHost: bindHost,
      );
    } catch (e) {
      debugPrint("❌ Error starting from ssconf URL: $e");
      return StartProxyResult(ok: false, error: e.toString());
    }
  }

  /// Stop local proxy
  static Future<void> stopLocalProxy() async {
    if (kIsWeb) return; // no-op on web
    await _sdkCh.invokeMethod('stopLocalProxy');
  }

  /// Tạo IOClient đi qua HTTP proxy (http CONNECT) tại `address` (vd: "127.0.0.1:54321")
  /// - [allowBadCerts] chỉ nên bật khi test nội bộ.
  /// - [timeout] có thể đặt timeout kết nối socket.
  static Future<IOClient> createHttpClientViaProxy(
    String address, {
    bool allowBadCerts = false,
    Duration? timeout,
  }) async {
    final io = HttpClient();

    // Bắt buộc định dạng "PROXY host:port"
    io.findProxy = (Uri uri) => "PROXY $address";

    if (allowBadCerts) {
      io.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    if (timeout != null) {
      io.connectionTimeout = timeout;
    }

    return IOClient(io);
  }

  static Future<Map?> startSsProxy() async {
    final cfg =
        'ss://chacha20-ietf-poly1305:OXCaAErI4aLdoKa0BdgIDN@150.136.131.140:443'
    // nếu cần prefix
    // '?prefix=%16%03%01%00%A8%01%01'
    ;
    final res = await _startLocalProxyWithConfig(cfg);
    if (!res.ok) return {'success': false, 'error': res.error};
    return {
      'success': true,
      'address': res.address,
      'host': res.host,
      'port': res.port,
    };
  }

  static String? _resolveConfigSource(KeyEntity.Key key) {
    if (key.fileName != null && key.fileName!.trim().isNotEmpty) {
      return key.fileName!.trim();
    }
    if (key.accessUrl.trim().isNotEmpty) {
      return key.accessUrl.trim();
    }
    return null;
  }

  static String _buildSsUriFromKey(KeyEntity.Key key, {String? remarks}) {
    return _buildLegacySsKey(
      host: key.serverName,
      port: key.port,
      method: key.method,
      password: key.password,
      remarks: remarks,
      prefixUtf8: key.prefix,
    );
  }

  static Future<StartProxyResult> startProxyForKey(
    KeyEntity.Key key, {
    int port = 0,
    String bindHost = '127.0.0.1',
  }) async {
    final source = _resolveConfigSource(key);

    if (source != null && source.toLowerCase().startsWith('ss://')) {
      final withRemarks = (key.name.isEmpty || source.contains('#'))
          ? source
          : '$source#${Uri.encodeComponent(key.name)}';
      return _startLocalProxyWithConfig(withRemarks,
          port: port, bindHost: bindHost);
    }

    if (source != null &&
        (source.toLowerCase().startsWith('ssconf://') ||
            source.toLowerCase().startsWith('https://') ||
            source.toLowerCase().startsWith('http://'))) {
      final res = await startFromSsconfUrl(
        source,
        port: port,
        bindHost: bindHost,
        remarks: key.name,
      );
      if (res.ok) {
        return res;
      }
    }

    final ssUri = _buildSsUriFromKey(key, remarks: key.name);
    return _startLocalProxyWithConfig(
      ssUri,
      port: port,
      bindHost: bindHost,
    );
  }

  static String buildConfigForKey(KeyEntity.Key key) {
    return _resolveConfigSource(key) ??
        _buildSsUriFromKey(key, remarks: key.name);
  }

  static Future<bool> startVpnTunnel({
    required String socksUpstream,
    String config = '',
    String port = '1080',
    bool perApp = false,
    String? keyId,
    String? keyName,
  }) async {
    if (kIsWeb) return false;
    final res = await _vpnCh.invokeMethod<bool>('startVpn', {
      'config': config,
      'port': port,
      'socks_upstream': socksUpstream,
      'per_app': perApp,
      if (keyId != null) 'key_id': keyId,
      if (keyName != null) 'key_name': keyName,
    });
    return res == true;
  }

  static Future<void> stopVpnTunnel() async {
    if (kIsWeb) return;
    await _vpnCh.invokeMethod('stopVpn');
  }
}
