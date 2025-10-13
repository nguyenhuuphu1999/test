import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class OutlineBridge {
  static const _ch = MethodChannel('com/example/vpncn2_app');
  static const _vpnCh = MethodChannel('vpncn2/vpn_service');
  static const _outlineCh = MethodChannel('outline_sdk');

  static Future<bool> ensureVpnPermission() async {
    final ok = await _vpnCh.invokeMethod<bool>('requestPermission');
    return ok == true;
  }

  static String _buildLegacySsKey({
    required String host,
    required int port,
    required String method,
    required String password,
    String? remarks,
  }) {
    final credB64 = base64Encode(
      utf8.encode('$method:$password'),
    ).replaceAll('\n', '');
    final tag = (remarks == null || remarks.isEmpty)
        ? ''
        : '#${Uri.encodeComponent(remarks)}';
    return 'ss://$credB64@$host:$port$tag';
  }

  static Future<bool> start({
    required String serverHost,
    required int serverPort, // cổng REMOTE (vd 443)
    required String method,
    required String password,
    required String remarks,
    int localPort = 1080, // cổng LOCAL cho proxy trong máy
  }) async {
    try {
      final ssKey = _buildLegacySsKey(
        host: serverHost,
        port: serverPort,
        method: method,
        password: password,
        remarks: remarks,
      );

      // 1) Start proxy local trên 127.0.0.1:<localPort>
      debugPrint('Starting Outline proxy on localPort=$localPort ...');
      final addr = await _ch.invokeMethod<String>('startOutlineProxy', {
        "key": ssKey,
        "port": localPort.toString(), // ✅ gửi đúng local port
      });
      if (addr == null || addr.isEmpty) {
        debugPrint('startOutlineProxy: no address returned');
        return false;
      }
      debugPrint('Local proxy address: $addr'); // ví dụ 127.0.0.1:1080

      _vpnCh.invokeMethod('startVpn', {
        "socks_upstream": addr,
        "per_app": true,
      });

      // 2) Xin quyền VPN (nếu chưa)
      final ok = await ensureVpnPermission();
      if (!ok) {
        debugPrint('User did not grant VPN permission');
        return false;
      }

      // 3) Bắt đầu Service VPN + truyền cả localSocks để tun2socks biết đẩy traffic
      final outlineResult = await _outlineCh.invokeMethod<String>(
        'connectWithKey',
        {
          "key": ssKey,
          "port": serverPort.toString(), // remote port (443)
          "localSocks": addr, // ✅ rất quan trọng
        },
      );
      debugPrint('outlineResult: $outlineResult');
      return true;
    } on PlatformException catch (e) {
      debugPrint('Exception in starting proxy: $e');
      return false;
    }
  }

  static Future<void> stop() => _ch.invokeMethod('stopOutline');
  static Future<String?> status() => _ch.invokeMethod<String>('getStatus');
}
