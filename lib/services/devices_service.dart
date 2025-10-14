import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../core/error/result.dart';
import '../features/devices/data/datasources/devices_api.dart';
import '../features/devices/data/repositories/devices_repository_impl.dart';
import '../features/devices/domain/entities/device.dart';
import '../features/devices/domain/repositories/devices_repository.dart';

class DevicesService {
  static bool _isInitialized = false;
  static late DevicesRepository _repository;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    await initSimpleDI();
    final dio = sl<Dio>();
    _repository = DevicesRepositoryImpl(DevicesApi(dio));
    _isInitialized = true;
  }

  static Future<
    Result<(List<DeviceItem>, int currentPage, int totalPages, int totalItems)>
  >
  getDevices({int page = 1, int limit = 10, String? search}) async {
    await initialize();
    return _repository.getDevices(page: page, limit: limit, search: search);
  }

  static Future<Result<DeviceDetail>> getDeviceDetail(String deviceId) async {
    await initialize();
    return _repository.getDeviceDetail(deviceId);
  }

  static Future<Result<void>> addDevice({
    required String deviceSerialNumber,
    required String deviceMacAddress,
    required String deviceAlias,
  }) async {
    await initialize();
    return _repository.addDevice(
      deviceSerialNumber: deviceSerialNumber,
      deviceMacAddress: deviceMacAddress,
      deviceAlias: deviceAlias,
    );
  }

  static Future<Result<void>> turnOnVpn(String deviceId) async {
    await initialize();
    return _repository.turnOnVpn(deviceId);
  }

  static Future<Result<void>> turnOffVpn(String deviceId) async {
    await initialize();
    return _repository.turnOffVpn(deviceId);
  }
}
