// lib/services/outline_brigde.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class StartProxyResult {
  final bool ok;
  final String? address;
  final String? host;
  final int? port;
  final String? error;
  StartProxyResult({
    required this.ok,
    this.address,
    this.host,
    this.port,
    this.error,
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

  /// Đọc ssconf://... → fetch JSON → tạo ss://... → start local proxy
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

      // 4) Gọi native để chạy local HTTP proxy qua Shadowsocks
      final res = await _sdkCh.invokeMapMethod<String, dynamic>(
        'startLocalProxy',
        {
          "preferSmart": false,
          "config": ssKey, // <<< QUAN TRỌNG: dùng chính ss://...
          "bindHost": bindHost,
          "port": port, // 0 = auto port
        },
      );

      if (res == null || res['success'] != true) {
        return StartProxyResult(
          ok: false,
          error: res?['error']?.toString() ?? 'Unknown error',
        );
      }

      return StartProxyResult(
        ok: true,
        address: res['address']?.toString(),
        host: res['host']?.toString(),
        port: (res['port'] is int)
            ? res['port'] as int
            : int.tryParse(res['port']?.toString() ?? ''),
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
    final res = await _sdkCh.invokeMethod<Map>('startLocalProxy', {
      'preferSmart': false,
      'bindHost': '127.0.0.1',
      'port': 0, // để hệ thống chọn port
      'config': cfg, // ✨ quan trọng: SS URI
    });
    return res;
  }
}
