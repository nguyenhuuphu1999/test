import '../../../../core/error/result.dart';
import '../entities/device.dart';

abstract class DevicesRepository {
  Future<
    Result<(List<DeviceItem>, int currentPage, int totalPages, int totalItems)>
  >
  getDevices({required int page, required int limit, String? search});

  Future<Result<DeviceDetail>> getDeviceDetail(String deviceId);

  Future<Result<void>> addDevice({
    required String deviceSerialNumber,
    required String deviceMacAddress,
    required String deviceAlias,
  });

  Future<Result<void>> turnOnVpn(String deviceId);
  Future<Result<void>> turnOffVpn(String deviceId);
}
