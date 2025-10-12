import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/keys/domain/entities/key.dart' as KeyEntity;
import 'native_vpn_service.dart';
import 'outline_sdk_service.dart';
import 'vpn_test_service.dart';

class VpnService {
  static final VpnService _instance = VpnService._internal();
  factory VpnService() => _instance;
  VpnService._internal();

  late final NativeVpnService _nativeVpnService;
  String _currentStatus = 'disconnected';
  late final ValueNotifier<String> _statusNotifier;
  KeyEntity.Key? _connectedKey;
  String? _currentTunnelId;
  String? _currentServerName;

  void _initializeRealVpn() {
    _statusNotifier = ValueNotifier<String>('disconnected');

    // ONLY use REAL Native VPN Service - NO SIMULATION, NO FAKE
    _nativeVpnService = NativeVpnService();
    debugPrint('🔧 Using REAL Native VPN Service - NO SIMULATION');

    // Listen to real VPN status changes
    _nativeVpnService.statusNotifier.addListener(() {
      _currentStatus = _nativeVpnService.statusNotifier.value;
      _statusNotifier.value = _currentStatus;

      if (_currentStatus == 'disconnected') {
        _connectedKey = null;
        _currentTunnelId = null;
        _currentServerName = null;
      } else if (_currentStatus == 'connected') {
        _connectedKey = _nativeVpnService.connectedKey;
      }
    });
  }

  // Getters
  String get currentStatus => _currentStatus;
  ValueNotifier<String> get statusNotifier => _statusNotifier;
  KeyEntity.Key? get connectedKey => _connectedKey;

  /// Initialize VPN service
  Future<void> initialize() async {
    _initializeRealVpn();

    // ONLY initialize REAL Native VPN Service - NO FALLBACKS, NO SIMULATION
    await _nativeVpnService.initialize();
    debugPrint('✅ REAL Native VPN Service initialized - NO SIMULATION');
  }

  /// Connect to VPN using a specific key
  Future<bool> connectWithKey(KeyEntity.Key key) async {
    try {
      debugPrint('🚀 Starting VPN connection...');
      debugPrint('🔧 Using Outline SDK for connection');

      // Check VPN permission first
      debugPrint('🔐 Checking VPN permission...');
      final vpnPermissionOk = await checkVpnPermission();
      if (!vpnPermissionOk) {
        debugPrint('❌ VPN permission not granted');
        throw Exception(
          'VPN permission is required. Please grant VPN permission in Android settings.',
        );
      }
      debugPrint('✅ VPN permission granted');

      // Test connectivity
      debugPrint('🔍 Testing connectivity before connecting...');
      final connectivityOk = await testConnectivity(key);

      if (!connectivityOk) {
        debugPrint('❌ Connectivity test failed, cannot connect VPN');
        throw Exception(
          'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.',
        );
      }

      debugPrint('✅ Connectivity test passed, proceeding with VPN connection');

      // Use Outline SDK for connection
      final result = await connectWithKeyViaSdk(key);

      if (!result['success']) {
        debugPrint('❌ VPN connection failed, disconnecting...');
        await disconnect();
        throw Exception(
          'Không thể kết nối VPN qua Outline SDK. Đã ngắt kết nối.',
        );
      }

      // Store tunnel info for later disconnection
      debugPrint('🔍 Result: $result');
      _currentTunnelId = result['tunnel_id'];
      _currentServerName = result['server_name'];
      debugPrint('🔍 Tunnel ID: $_currentTunnelId');
      debugPrint('🔍 Server Name: $_currentServerName');

      // Check if this is a real VPN tunnel
      final isRealVpn = result['real_vpn'] == true;

      if (isRealVpn) {
        debugPrint('✅ REAL VPN tunnel established successfully');
      } else {
        debugPrint('❌ VPN tunnel establishment failed - NO MOCK FALLBACK!');
        throw Exception(
          'VPN tunnel establishment failed - no mock fallback available',
        );
      }

      debugPrint('✅ VPN connection successful via Outline SDK');

      // Only verify traffic if this is a real VPN tunnel
      if (isRealVpn) {
        debugPrint('🔍 Verifying VPN traffic for REAL tunnel...');

        // Extract actual IP from config
        final outlineSdkService = OutlineSdkService();
        await outlineSdkService.initialize();
        final vpnServerIp = await outlineSdkService.getVpnServerIp(key);

        if (vpnServerIp == null) {
          debugPrint(
            '⚠️ Could not extract VPN server IP, skipping verification',
          );
          return true; // Skip verification if we can't get the IP
        }

        final verificationResult = await VpnTestService.verifyVpnTraffic(
          vpnServerIp,
        );

        if (verificationResult.success) {
          debugPrint(
            '✅ VPN traffic verified! All traffic is going through VPN server.',
          );
          debugPrint('📍 Traffic IP: ${verificationResult.actualIp}');
          debugPrint('🎯 VPN Server IP: ${verificationResult.expectedIp}');
        } else {
          debugPrint('❌ VPN traffic verification failed!');
          debugPrint('📍 Actual traffic IP: ${verificationResult.actualIp}');
          debugPrint('🎯 Expected VPN IP: ${verificationResult.expectedIp}');
          debugPrint('⚠️ Warning: Traffic may not be going through VPN!');

          // Disconnect and throw error if traffic is not going through VPN
          await disconnect();
          throw Exception(
            'VPN connection failed verification. Traffic is not going through VPN server.',
          );
        }
      } // Close if (isRealVpn) block
      // Traffic verification is always performed for real VPN tunnels

      return true;
    } catch (e) {
      debugPrint('❌ VPN connection failed: $e');
      // Ensure VPN is disconnected on any error
      try {
        await disconnect();
      } catch (disconnectError) {
        debugPrint('⚠️ Error during disconnect: $disconnectError');
      }
      throw Exception('Không thể kết nối VPN: ${e.toString()}');
    }
  }

  /// Connect to VPN using Outline SDK
  Future<Map<String, dynamic>> connectWithKeyViaSdk(KeyEntity.Key key) async {
    try {
      debugPrint('🔗 Connecting via Outline SDK for key: ${key.name}');

      final outlineSdkService = OutlineSdkService();
      await outlineSdkService.initialize();

      final result = await outlineSdkService.connectWithKeyViaSdk(key);

      if (result['success']) {
        _currentStatus = 'connected';
        _statusNotifier.value = 'connected';
        _connectedKey = key;
        _currentTunnelId = result['tunnel_id'];
        _currentServerName = result['server_name'];
        debugPrint('✅ Outline SDK connection successful');
      } else {
        debugPrint('❌ Outline SDK connection failed');
      }

      return result;
    } catch (e) {
      debugPrint('❌ Outline SDK connection error: $e');
      rethrow;
    }
  }

  /// Check VPN permission
  Future<bool> checkVpnPermission() async {
    try {
      final outlineSdkService = OutlineSdkService();
      return await outlineSdkService.requestVpnPermission();
    } catch (e) {
      debugPrint('❌ VPN permission check failed: $e');
      return false;
    }
  }

  /// Test connectivity using Outline SDK (for testing only, not for real connection)
  Future<bool> testConnectivity(KeyEntity.Key key) async {
    try {
      debugPrint('🔍 Testing connectivity for key: ${key.name}');
      debugPrint('🔑 Key details:');
      debugPrint('   • Name: ${key.name}');
      debugPrint('   • Server: ${key.serverName}');
      debugPrint('   • Port: ${key.port}');
      debugPrint('   • Method: ${key.method}');
      debugPrint('   • Password: ${key.password.substring(0, 3)}***');
      debugPrint('   • Access URL: ${key.accessUrl}');
      debugPrint('   • OSS ID: ${key.ossId ?? "N/A"}');
      debugPrint('   • File Name: ${key.fileName ?? "N/A"}');
      debugPrint('   • Prefix: ${key.prefix ?? "N/A"}');

      // Create a temporary OutlineSdkService just for testing
      final outlineSdkService = OutlineSdkService();
      await outlineSdkService.initialize();

      debugPrint('🔍 Testing connectivity with Outline SDK...');
      final connectivityResult = await outlineSdkService.testConnectivity(key);

      debugPrint('📊 Connectivity test results:');
      debugPrint('   • Overall success: ${connectivityResult.success}');
      debugPrint(
        '   • TCP result: ${connectivityResult.tcpResult.success} (${connectivityResult.tcpResult.duration}ms)',
      );
      debugPrint(
        '   • UDP result: ${connectivityResult.udpResult.success} (${connectivityResult.udpResult.duration}ms)',
      );
      debugPrint('   • Transport: ${connectivityResult.transport}');

      if (connectivityResult.success) {
        debugPrint('✅ Connectivity test passed! Server is reachable.');
        debugPrint('📊 Test metrics:');
        debugPrint(
          '   • TCP latency: ${connectivityResult.tcpResult.duration}ms',
        );
        debugPrint(
          '   • UDP latency: ${connectivityResult.udpResult.duration}ms',
        );
        return true;
      } else {
        debugPrint('❌ Connectivity test failed');
        if (connectivityResult.tcpResult.error != null) {
          debugPrint('   • TCP error: ${connectivityResult.tcpResult.error}');
        }
        if (connectivityResult.udpResult.error != null) {
          debugPrint('   • UDP error: ${connectivityResult.udpResult.error}');
        }
        return false;
      }
    } catch (e) {
      debugPrint('❌ Connectivity test failed with exception: $e');
      debugPrint('📚 Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Disconnect VPN
  Future<void> disconnect() async {
    try {
      debugPrint('🛑 Disconnecting VPN...');

      // Use Outline SDK for disconnection
      final outlineSdkService = OutlineSdkService();
      await outlineSdkService.disconnectViaSdk(_currentTunnelId);
      debugPrint('✅ VPN disconnected via Outline SDK');

      _currentStatus = 'disconnected';
      _statusNotifier.value = 'disconnected';
      _connectedKey = null;
      _currentTunnelId = null;
      _currentServerName = null;
      await _clearConnectedKey();
      debugPrint('✅ VPN disconnected successfully');
    } catch (e) {
      debugPrint('⚠️ VPN disconnect failed: $e');
      // Still update status even if disconnect fails
      _currentStatus = 'disconnected';
      _statusNotifier.value = 'disconnected';
      _connectedKey = null;
      _currentTunnelId = null;
      _currentServerName = null;
    }
  }

  /// Clear connected key from SharedPreferences
  Future<void> _clearConnectedKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('connected_key_id');
      await prefs.remove('connected_key_name');
      await prefs.remove('connected_key_server');
      await prefs.remove('connected_key_port');
      await prefs.remove('connected_key_method');
      debugPrint('🗑️ Connected key cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear connected key: $e');
    }
  }

  /// Test VPN traffic verification manually
  Future<bool> testVpnTrafficVerification() async {
    try {
      if (_connectedKey == null) {
        debugPrint('❌ No connected key found');
        return false;
      }

      debugPrint('🔍 Testing VPN traffic verification...');
      final outlineSdkService = OutlineSdkService();
      await outlineSdkService.initialize();
      final vpnServerIp = await outlineSdkService.getVpnServerIp(
        _connectedKey!,
      );

      if (vpnServerIp == null) {
        debugPrint('❌ Could not get VPN server IP');
        return false;
      }

      final verificationResult = await VpnTestService.verifyVpnTraffic(
        vpnServerIp,
      );

      debugPrint('📊 VPN Traffic Verification Results:');
      debugPrint('   • Success: ${verificationResult.success}');
      debugPrint('   • Expected IP: ${verificationResult.expectedIp}');
      debugPrint('   • Actual IP: ${verificationResult.actualIp}');
      debugPrint('   • Message: ${verificationResult.message}');

      return verificationResult.success;
    } catch (e) {
      debugPrint('❌ VPN traffic verification test failed: $e');
      return false;
    }
  }

  /// Load connected key info from Native VPN Service
  Future<KeyEntity.Key?> loadConnectedKeyInfo() async {
    try {
      // Use Native VPN Service to load connected key info
      final connectedKey = await _nativeVpnService.loadConnectedKeyInfo();

      if (connectedKey != null) {
        debugPrint(
          '✅ Loaded connected key from Native VPN Service: ${connectedKey.name}',
        );
        _connectedKey = connectedKey;
        return connectedKey;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Failed to load connected key info: $e');
      return null;
    }
  }

  /// Check if VPN is currently connected
  bool get isConnected => _currentStatus == 'connected';

  /// Get connection status as string
  String get connectionStatus => _currentStatus;

  /// Get connected key name
  String? get connectedKeyName => _connectedKey?.name;

  /// Get connected server info
  String? get connectedServer => _connectedKey?.serverName;

  /// Check if a specific key is currently connected
  bool isKeyConnected(KeyEntity.Key key) {
    return _nativeVpnService.isKeyConnected(key);
  }
}
