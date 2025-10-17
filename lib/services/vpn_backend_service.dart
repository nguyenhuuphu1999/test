import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../core/error/result.dart';

class VpnBackendService {
  static bool _initialized = false;
  static late Dio _dio;

  static Future<void> initialize() async {
    if (_initialized) return;
    await initSimpleDI();
    _dio = sl<Dio>();
    _initialized = true;
  }

  static Future<Result<void>> updateDeviceVpnStatus({
    required String keyId,
    required bool connected,
  }) async {
    await initialize();
    try {
      await _dio.post(
        '/mobile/device/vpn/status',
        data: {
          'status': connected ? 'CONNECTED' : 'DISCONNECTED',
          'keyId': keyId,
        },
        options: Options(headers: {'accept': 'application/json'}),
      );
      return Result.ok(null);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }
}
