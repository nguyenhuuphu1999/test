import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../features/keys/domain/entities/key.dart' as KeyEntity;

/// Outline SDK Service for real network operations
class OutlineSdkService {
  static final OutlineSdkService _instance = OutlineSdkService._internal();
  factory OutlineSdkService() => _instance;
  OutlineSdkService._internal();

  static const MethodChannel _channel = MethodChannel('outline_sdk');
  bool _isInitialized = false;

  /// Initialize Outline SDK with platform channels
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      debugPrint('🔧 Initializing Outline SDK...');
      try {
        // First test basic connectivity
        await _channel.invokeMethod('ping');
        debugPrint('✅ Platform channel test successful');

        // Initialize Outline SDK
        final initResult = await _channel.invokeMethod('outlineInit');
        final initData = json.decode(initResult as String);
        if (initData['success'] == true) {
          _isInitialized = true;
          debugPrint('✅ Outline SDK initialized successfully');
        } else {
          throw Exception('Outline SDK initialization failed');
        }
      } catch (e) {
        debugPrint('❌ Outline SDK initialization failed: $e');
        throw Exception('Failed to initialize Outline SDK: $e');
      }
    } catch (e) {
      debugPrint('❌ Outline SDK initialization failed: $e');
      rethrow;
    }
  }

  /// Check and request VPN permission
  Future<bool> requestVpnPermission() async {
    try {
      debugPrint('🔐 Requesting VPN permission...');
      final response = await _channel.invokeMethod('requestVpnPermission');
      final data = json.decode(response as String);

      if (data['granted'] == true) {
        debugPrint('✅ VPN permission already granted');
        return true;
      } else if (data['intent'] == 'VPN_PERMISSION_STARTED') {
        debugPrint(
          '🚀 VPN permission dialog started - user will interact with system',
        );
        debugPrint(
          'ℹ️ VPN permission dialog opened. Please grant permission and try connecting again.',
        );
        // Permission dialog is shown, user will grant/deny
        // We return false for now, user needs to retry after granting
        return false;
      } else {
        debugPrint('❌ VPN permission needed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ VPN permission request failed: $e');
      return false;
    }
  }

  /// Create Shadowsocks transport from key
  String createShadowsocksTransport(KeyEntity.Key key) {
    try {
      debugPrint('🔗 Creating Shadowsocks transport from key...');
      String configSource;
      debugPrint('key.fileName============: ${key.fileName}');
      if (key.fileName != null && key.fileName!.isNotEmpty) {
        // GIỮ NGUYÊN https, đừng đổi sang ssconf ở đây
        configSource = key.fileName!;
        debugPrint('🔗 Using fileName from ossId/awsId: $configSource');
      } else {
        configSource = key.accessUrl;
        debugPrint('🔗 Using accessUrl: $configSource');
      }

      // Trường hợp đã là ss:// -> dùng luôn
      if (configSource.startsWith('ss://')) {
        debugPrint(
          '🔗 Using direct ss URL: ${configSource.substring(0, 30)}...',
        );
        return configSource;
      }

      // Trường hợp là ssconf:// -> để native tự normalize
      if (configSource.startsWith('ssconf://')) {
        debugPrint('🔗 Using ssconf URL: ${configSource.substring(0, 30)}...');
        return configSource;
      }

      // Trường hợp là https:// -> trả về để fetch JSON
      if (configSource.startsWith('https://')) {
        debugPrint('🔗 Config source is HTTPS URL: $configSource');
        return configSource;
      }

      // Build ss:// from key
      final encodedPassword = Uri.encodeComponent(key.password);
      return 'ss://${key.method}:$encodedPassword@${key.serverName}:${key.port}';
    } catch (e) {
      debugPrint('❌ Failed to create Shadowsocks transport: $e');
      throw Exception('Failed to create transport: $e');
    }
  }

  /// Test connectivity using Outline SDK
  Future<ConnectivityResult> testConnectivity(KeyEntity.Key key) async {
    try {
      debugPrint('🔍 OutlineSdkService: Starting connectivity test...');
      if (!_isInitialized) {
        debugPrint('🔧 Service not initialized, initializing now...');
        await initialize();
      }

      debugPrint('🔍 Testing connectivity for key: ${key.name}');
      debugPrint('📋 Key parameters:');
      debugPrint('   • Server: ${key.serverName}');
      debugPrint('   • Port: ${key.port}');
      debugPrint('   • Method: ${key.method}');

      debugPrint('🌐 Creating Shadowsocks transport...');
      String transport = createShadowsocksTransport(key);
      debugPrint(
        '✅ Transport created: ${transport.substring(0, transport.length > 50 ? 50 : transport.length)}...',
      );
      debugPrint('🔍 Full transport string: $transport');

      // Nếu là URL remote (https/ssconf) -> phải fetch JSON trước (normal -> bypass)
      if (transport.startsWith('https://') ||
          transport.startsWith('ssconf://')) {
        debugPrint('🔗 Fetching config from remote URL...');
        Map<String, dynamic>? configJson;

        // Fetch config using REAL Outline SDK
        try {
          debugPrint('🔗 Fetching config using REAL Outline SDK...');
          final cfg = await _channel.invokeMethod('outlineFetch', {
            'url': transport,
            'config': json.encode({
              'server': key.serverName,
              'server_port': key.port,
              'method': key.method,
              'password': key.password,
            }),
          });

          // Handle both String and Map responses
          Map<String, dynamic> cfgData;
          if (cfg is String) {
            cfgData = json.decode(cfg);
          } else if (cfg is Map<String, dynamic>) {
            cfgData = cfg;
          } else {
            throw Exception('Unexpected response type: ${cfg.runtimeType}');
          }
          if (cfgData['success'] == true) {
            // Handle response body - could be String or Map
            final body = cfgData['body'];
            if (body is String) {
              configJson = json.decode(body) as Map<String, dynamic>;
            } else if (body is Map<String, dynamic>) {
              configJson = body;
            } else {
              throw Exception('Unexpected body type: ${body.runtimeType}');
            }
            debugPrint(
              '📄 Config fetched successfully via REAL Outline SDK: ${configJson.keys}',
            );
          } else {
            debugPrint('❌ REAL Outline SDK fetch failed: ${cfgData['error']}');
            throw PlatformException(
              code: 'FETCH_ERROR',
              message: '${cfgData['error']}',
            );
          }
        } catch (e) {
          debugPrint('❌ REAL Outline SDK fetch failed: $e');
          // Build ss:// directly from key
          final encodedPassword = Uri.encodeComponent(key.password);
          transport =
              'ss://${key.method}:$encodedPassword@${key.serverName}:${key.port}';
          debugPrint(
            '🔄 Using transport from key: ${transport.substring(0, 30)}...',
          );
        }

        if (configJson != null) {
          transport = _parseConfigToShadowsocksUrl(configJson, key);
          debugPrint(
            '🔗 Parsed to ss:// URL: ${transport.substring(0, 30)}...',
          );
        }
      }

      // Lấy server/port để test DNS/TCP/UDP
      debugPrint('🔍 Testing connectivity with native platform channel...');
      String server = _extractServerFromTransport(transport);
      int port = _extractPortFromTransport(transport, defaultPort: key.port);
      if (server.isEmpty) server = key.serverName;

      debugPrint('📋 Final server config - Server: $server, Port: $port');
      debugPrint('📋 Key details:');
      debugPrint('   • Key serverName: ${key.serverName}');
      debugPrint('   • Key port: ${key.port}');
      debugPrint('   • Extracted server: $server');
      debugPrint('   • Extracted port: $port');
      debugPrint('   • Full transport: $transport');
      debugPrint(
        '   • Transport preview: ${transport.substring(0, transport.length > 50 ? 50 : transport.length)}...',
      );

      final connectivityResponse = await _channel.invokeMethod(
        'outlineTestReachability',
        {
          'config': json.encode({
            'server': server,
            'server_port': port,
            'method': key.method,
            'password': key.password,
          }),
        },
      );

      final connectivityData = json.decode(connectivityResponse as String);
      debugPrint('📊 Native connectivity test completed');
      debugPrint('📊 Raw connectivity response: $connectivityData');

      final tcpResult = DnsResult(
        success: connectivityData['tcp_result']['success'] as bool,
        duration: connectivityData['tcp_result']['duration_ms'] as int,
        error: connectivityData['tcp_result']['error'] as String?,
      );
      final udpResult = DnsResult(
        success: connectivityData['udp_result']['success'] as bool,
        duration: connectivityData['udp_result']['duration_ms'] as int,
        error: connectivityData['udp_result']['error'] as String?,
      );

      debugPrint('📊 Parsed results:');
      debugPrint(
        '   • TCP: ${tcpResult.success} (${tcpResult.duration}ms) ${tcpResult.error ?? ""}',
      );
      debugPrint(
        '   • UDP: ${udpResult.success} (${udpResult.duration}ms) ${udpResult.error ?? ""}',
      );

      // Use the overall result from Kotlin (which considers TCP success sufficient)
      final success = connectivityData['success'] as bool;
      debugPrint('🎯 Overall connectivity result from native: $success');
      debugPrint(
        '🎯 TCP success: ${tcpResult.success}, UDP success: ${udpResult.success}',
      );

      final result = ConnectivityResult(
        success: success,
        tcpResult: tcpResult,
        udpResult: udpResult,
        transport: transport,
      );
      debugPrint('✅ Connectivity test completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Connectivity test failed with exception: $e');
      debugPrint('📚 Stack trace: ${StackTrace.current}');
      final errorResult = ConnectivityResult(
        success: false,
        tcpResult: DnsResult(success: false, duration: 0, error: e.toString()),
        udpResult: DnsResult(success: false, duration: 0, error: e.toString()),
        transport: '',
      );
      debugPrint('🔄 Returning error result');
      return errorResult;
    }
  }

  /// Parse config JSON to ss://
  String _parseConfigToShadowsocksUrl(
    Map<String, dynamic> configJson,
    KeyEntity.Key key,
  ) {
    try {
      debugPrint('🔍 Parsing config JSON...');
      String server = key.serverName;
      int port = key.port;
      String method = key.method;
      String password = key.password;

      if (configJson.containsKey('server')) {
        server = configJson['server'] as String;
        debugPrint('   • Server from config: $server');
      }
      if (configJson.containsKey('server_port')) {
        port = configJson['server_port'] as int;
        debugPrint('   • Port from config: $port');
      }
      if (configJson.containsKey('method')) {
        method = configJson['method'] as String;
        debugPrint('   • Method from config: $method');
      }
      if (configJson.containsKey('password')) {
        password = configJson['password'] as String;
        debugPrint('   • Password from config: ${password.substring(0, 3)}***');
      }

      final encodedPassword = Uri.encodeComponent(password);
      final shadowsocksUrl = 'ss://$method:$encodedPassword@$server:$port';
      debugPrint(
        '✅ Parsed Shadowsocks URL: ${shadowsocksUrl.substring(0, 30)}...',
      );
      return shadowsocksUrl;
    } catch (e) {
      debugPrint('❌ Error parsing config: $e');
      final encodedPassword = Uri.encodeComponent(key.password);
      return 'ss://${key.method}:$encodedPassword@${key.serverName}:${key.port}';
    }
  }

  String _extractServerFromTransport(String transport) {
    try {
      debugPrint('🔍 Parsing transport: $transport');
      final uri = Uri.parse(transport);
      debugPrint('🔍 Parsed URI - scheme: ${uri.scheme}, host: ${uri.host}');

      if (uri.scheme == 'ss' ||
          uri.scheme == 'ssconf' ||
          uri.scheme == 'https') {
        final host = uri.host;
        debugPrint('🔍 Extracted host: $host');
        return host;
      }
      return '';
    } catch (e) {
      debugPrint('❌ Error parsing transport: $e');
      return '';
    }
  }

  int _extractPortFromTransport(String transport, {int? defaultPort}) {
    try {
      final uri = Uri.parse(transport);
      if (uri.hasPort && uri.port > 0) return uri.port;
    } catch (_) {}
    return defaultPort ?? 443;
  }

  /// Fetch URL through Outline transport (with optional bypass)
  Future<FetchResult> fetchUrl(
    String url,
    KeyEntity.Key key, {
    bool bypass = false,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      debugPrint(
        '🌐 Fetching URL through Outline transport: $url | bypass=$bypass',
      );

      // Use new Outline SDK method
      final response = await _channel.invokeMethod('outlineFetch', {
        'url': url,
        'config': json.encode({
          'server': key.serverName,
          'server_port': key.port,
          'method': key.method,
          'password': key.password,
        }),
      });
      final data = json.decode(response as String);

      return FetchResult(
        success: data['success'] as bool,
        statusCode: data['status_code'] as int? ?? 0,
        headers: const {},
        body: data['body'] as String? ?? '',
        error: data['error'] as String?,
      );
    } catch (e) {
      debugPrint('❌ REAL Outline SDK fetch failed: $e');
      return FetchResult(
        success: false,
        statusCode: 0,
        headers: {},
        body: '',
        error: e.toString(),
      );
    }
  }

  Future<SpeedResult> testDownloadSpeed(String url, KeyEntity.Key key) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      debugPrint('🚀 Testing download speed via Outline SDK: $url');

      // Use new Outline SDK method
      final response = await _channel.invokeMethod('outlineSpeedTest', {
        'url': url,
        'config': json.encode({
          'server': key.serverName,
          'server_port': key.port,
          'method': key.method,
          'password': key.password,
        }),
      });
      final data = json.decode(response as String);
      return SpeedResult(
        success: data['success'] as bool,
        speedMbps: (data['speed_mbps'] as num?)?.toDouble() ?? 0.0,
        duration: data['duration_ms'] as int? ?? 0,
        bytesDownloaded: data['bytes_downloaded'] as int? ?? 0,
        error: data['error'] as String?,
      );
    } catch (e) {
      debugPrint('❌ REAL Outline speed test failed: $e');
      return SpeedResult(
        success: false,
        speedMbps: 0.0,
        duration: 0,
        bytesDownloaded: 0,
        error: e.toString(),
      );
    }
  }

  /// Extract actual VPN server IP from config
  Future<String?> getVpnServerIp(KeyEntity.Key key) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Try to get IP from fileName (remote config)
      if (key.fileName != null && key.fileName!.startsWith('http')) {
        debugPrint('🔍 Fetching VPN server IP from remote config...');
        final result = await testConnectivity(key);
        if (result.success && result.transport.contains('@')) {
          // Extract IP from transport string like "ss://...@172.233.89.154:443"
          final ipMatch = RegExp(
            r'@([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):',
          ).firstMatch(result.transport);
          if (ipMatch != null) {
            final ip = ipMatch.group(1)!;
            debugPrint('🎯 Extracted VPN server IP: $ip');
            return ip;
          }
        }
      }

      // Use serverName if it looks like an IP
      if (RegExp(
        r'^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$',
      ).hasMatch(key.serverName)) {
        debugPrint('🎯 Using serverName as IP: ${key.serverName}');
        return key.serverName;
      }

      debugPrint('⚠️ Could not extract VPN server IP');
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get VPN server IP: $e');
      return null;
    }
  }

  Future<ProxyResult> startLocalProxy(
    KeyEntity.Key key, {
    int localPort = 8080,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      debugPrint('🔧 Starting local proxy on port $localPort');
      return ProxyResult(
        success: false,
        localPort: localPort,
        error: 'Local proxy not implemented yet',
      );
    } catch (e) {
      debugPrint('❌ Local proxy start failed: $e');
      return ProxyResult(
        success: false,
        localPort: localPort,
        error: e.toString(),
      );
    }
  }

  Future<void> stopLocalProxy() async {
    try {
      debugPrint('🛑 Stopping local proxy');
    } catch (e) {
      debugPrint('❌ Error stopping local proxy: $e');
    }
  }

  /// Connect to VPN using Outline SDK
  Future<Map<String, dynamic>> connectWithKeyViaSdk(KeyEntity.Key key) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      debugPrint('🔗 Connecting via Outline SDK for key: ${key.name}');

      final response = await _channel.invokeMethod('outlineStart', {
        'config': json.encode({
          'server': key.serverName,
          'server_port': key.port,
          'method': key.method,
          'password': key.password,
        }),
      });
      final data = json.decode(response as String);

      if (data['success'] == true) {
        debugPrint('✅ VPN tunnel connection successful');
        return {
          'success': true,
          'tunnel_id': data['tunnel_id'],
          'server_name': data['server_name'],
        };
      } else {
        throw Exception('VPN tunnel connection failed: ${data['error']}');
      }
    } catch (e) {
      debugPrint('❌ VPN tunnel connection error: $e');
      rethrow;
    }
  }

  /// Disconnect VPN using Outline SDK
  Future<void> disconnectViaSdk([String? tunnelId]) async {
    try {
      debugPrint('🛑 Disconnecting via Outline SDK');
      await _channel.invokeMethod('outlineStop', {'tunnel_id': tunnelId});
      debugPrint('✅ VPN tunnel disconnected');
    } catch (e) {
      debugPrint('❌ VPN tunnel disconnect error: $e');
    }
  }
}

/// Data classes for results
class ConnectivityResult {
  final bool success;
  final DnsResult tcpResult;
  final DnsResult udpResult;
  final String transport;
  ConnectivityResult({
    required this.success,
    required this.tcpResult,
    required this.udpResult,
    required this.transport,
  });
}

class DnsResult {
  final bool success;
  final int duration;
  final String? error;
  DnsResult({required this.success, required this.duration, this.error});
}

class FetchResult {
  final bool success;
  final int statusCode;
  final Map<String, String> headers;
  final String body;
  final String? error;
  FetchResult({
    required this.success,
    required this.statusCode,
    required this.headers,
    required this.body,
    this.error,
  });
}

class SpeedResult {
  final bool success;
  final double speedMbps;
  final int duration;
  final int bytesDownloaded;
  final String? error;
  SpeedResult({
    required this.success,
    required this.speedMbps,
    required this.duration,
    required this.bytesDownloaded,
    this.error,
  });
}

class ProxyResult {
  final bool success;
  final int localPort;
  final String? error;
  ProxyResult({required this.success, required this.localPort, this.error});
}
