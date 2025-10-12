import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Test service to verify VPN connection
class VpnTestService {
  static const String testUrl = 'https://httpbin.org/ip';
  static const String ipifyUrl = 'https://api.ipify.org?format=json';
  static const String ipinfoUrl = 'https://ipinfo.io/json';

  /// Test if VPN is working by checking IP address matches VPN server IP
  static Future<VpnVerificationResult> verifyVpnTraffic(
    String expectedVpnServerIp,
  ) async {
    try {
      debugPrint('🔍 Verifying VPN traffic...');
      debugPrint('🎯 Expected VPN server IP: $expectedVpnServerIp');

      // Get current IP from multiple sources for verification
      final ipResults = await Future.wait([
        _getIpFromHttpbin(),
        _getIpFromIpify(),
        _getIpFromIpinfo(),
      ]);

      // Check if any IP matches the VPN server
      bool trafficMatchesVpn = false;
      String? actualIp;

      for (final result in ipResults) {
        if (result['success'] == true && result['ip'] != null) {
          actualIp = result['ip'];
          if (actualIp == expectedVpnServerIp) {
            trafficMatchesVpn = true;
            break;
          }
        }
      }

      debugPrint('📍 Actual traffic IP: $actualIp');
      debugPrint('🎯 Expected VPN IP: $expectedVpnServerIp');
      debugPrint('✅ Traffic matches VPN: $trafficMatchesVpn');

      return VpnVerificationResult(
        success: trafficMatchesVpn,
        expectedIp: expectedVpnServerIp,
        actualIp: actualIp,
        message: trafficMatchesVpn
            ? '✅ VPN traffic verified! All traffic is going through VPN server.'
            : '❌ VPN traffic verification failed! Traffic is NOT going through VPN.',
      );
    } catch (e) {
      debugPrint('❌ VPN verification failed: $e');
      return VpnVerificationResult(
        success: false,
        expectedIp: expectedVpnServerIp,
        actualIp: null,
        message: 'VPN verification error: $e',
      );
    }
  }

  /// Get IP from httpbin.org
  static Future<Map<String, dynamic>> _getIpFromHttpbin() async {
    try {
      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'ip': data['origin'] as String?};
      }
    } catch (e) {
      debugPrint('❌ Httpbin IP check failed: $e');
    }
    return {'success': false, 'ip': null};
  }

  /// Get IP from ipify.org
  static Future<Map<String, dynamic>> _getIpFromIpify() async {
    try {
      final response = await http
          .get(Uri.parse(ipifyUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'ip': data['ip'] as String?};
      }
    } catch (e) {
      debugPrint('❌ Ipify IP check failed: $e');
    }
    return {'success': false, 'ip': null};
  }

  /// Get IP from ipinfo.io
  static Future<Map<String, dynamic>> _getIpFromIpinfo() async {
    try {
      final response = await http
          .get(Uri.parse(ipinfoUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'ip': data['ip'] as String?};
      }
    } catch (e) {
      debugPrint('❌ Ipinfo IP check failed: $e');
    }
    return {'success': false, 'ip': null};
  }

  /// Test if VPN is working by checking IP address (legacy method)
  static Future<VpnTestResult> testVpnConnection() async {
    try {
      debugPrint('🔍 Testing VPN connection...');

      // Get current IP
      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ip = data['origin'] as String?;

        debugPrint('📍 Current IP: $ip');

        return VpnTestResult(
          success: true,
          ip: ip,
          message: 'VPN connection test completed',
        );
      } else {
        return VpnTestResult(
          success: false,
          ip: null,
          message: 'Failed to get IP: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ VPN test failed: $e');
      return VpnTestResult(
        success: false,
        ip: null,
        message: 'VPN test error: $e',
      );
    }
  }

  /// Get connection speed test
  static Future<SpeedTestResult> testConnectionSpeed() async {
    try {
      debugPrint('⚡ Testing connection speed...');

      final stopwatch = Stopwatch()..start();

      // Download a small file to test speed
      final response = await http
          .get(
            Uri.parse('https://httpbin.org/bytes/1024'), // 1KB test file
          )
          .timeout(const Duration(seconds: 10));

      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytesReceived = response.bodyBytes.length;
        final timeMs = stopwatch.elapsedMilliseconds;
        final speedKbps = (bytesReceived * 8) / timeMs; // Convert to Kbps

        debugPrint('📊 Speed test: ${speedKbps.toStringAsFixed(2)} Kbps');

        return SpeedTestResult(
          success: true,
          speedKbps: speedKbps,
          latencyMs: timeMs,
          message: 'Speed test completed',
        );
      } else {
        return SpeedTestResult(
          success: false,
          speedKbps: 0,
          latencyMs: 0,
          message: 'Speed test failed: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Speed test failed: $e');
      return SpeedTestResult(
        success: false,
        speedKbps: 0,
        latencyMs: 0,
        message: 'Speed test error: $e',
      );
    }
  }
}

/// Result of VPN connection test
class VpnTestResult {
  final bool success;
  final String? ip;
  final String message;

  const VpnTestResult({required this.success, this.ip, required this.message});

  @override
  String toString() {
    return 'VpnTestResult(success: $success, ip: $ip, message: $message)';
  }
}

/// Result of connection speed test
class SpeedTestResult {
  final bool success;
  final double speedKbps;
  final int latencyMs;
  final String message;

  const SpeedTestResult({
    required this.success,
    required this.speedKbps,
    required this.latencyMs,
    required this.message,
  });

  @override
  String toString() {
    return 'SpeedTestResult(success: $success, speedKbps: ${speedKbps.toStringAsFixed(2)}, latencyMs: $latencyMs, message: $message)';
  }
}

/// Result of VPN traffic verification
class VpnVerificationResult {
  final bool success;
  final String expectedIp;
  final String? actualIp;
  final String message;

  const VpnVerificationResult({
    required this.success,
    required this.expectedIp,
    required this.actualIp,
    required this.message,
  });

  @override
  String toString() {
    return 'VpnVerificationResult(success: $success, expectedIp: $expectedIp, actualIp: $actualIp, message: $message)';
  }
}
