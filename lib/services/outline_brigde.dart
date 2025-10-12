import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class OutlineBridge {
  static const _ch = MethodChannel('com/example/vpncn2_app');
  static const _vpnCh = MethodChannel('vpncn2/vpn_service');

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
    // base64("method:password")
    final credB64 = base64Encode(
      utf8.encode('$method:$password'),
    ).replaceAll('\n', ''); // safety: no newlines
    final tag = (remarks == null || remarks.isEmpty)
        ? ''
        : '#${Uri.encodeComponent(remarks)}';
    return 'ss://$credB64@$host:$port$tag';
  }

  // If your library ever supports SIP002, you can try this instead:
  static String _buildSip002SsKey({
    required String host,
    required int port,
    required String method,
    required String password,
    String? remarks,
  }) {
    final tag = (remarks == null || remarks.isEmpty)
        ? ''
        : '#${Uri.encodeComponent(remarks)}';
    final pw = Uri.encodeComponent(password);
    final meth = Uri.encodeComponent(method);
    return 'ss://$meth:$pw@$host:$port/?outline=1$tag';
  }

  static Future<bool> start({
    required String serverHost,
    required int serverPort,
    required String method,
    required String password,
    required String remarks,
  }) async {
    try {
      // Build a LEGACY key because your Android side is decoding base64
      final ssKey = _buildLegacySsKey(
        host: serverHost,
        port: serverPort,
        method: method,
        password: password,
        remarks: remarks,
      );

      debugPrint('Starting Outline proxy on port $serverPort ...');
      debugPrint('serverHost: $serverHost');
      debugPrint('ssKey: $ssKey');
      final result = await _ch.invokeMethod<String>('startOutlineProxy', {
        "key": ssKey,
        "port": serverHost.toString(),
      });

      debugPrint('result: $result');
      return true;
    } on PlatformException catch (e) {
      debugPrint('Exception in starting proxy $e');
      return false;
    }
  }

  static Future<void> stop() => _ch.invokeMethod('stopOutline');
  static Future<String?> status() => _ch.invokeMethod<String>('getStatus');
}
