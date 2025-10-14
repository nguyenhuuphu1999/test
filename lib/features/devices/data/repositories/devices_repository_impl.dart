import '../../../../core/error/result.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/devices_repository.dart';
import '../datasources/devices_api.dart';
import '../models/device_dto.dart';

class DevicesRepositoryImpl implements DevicesRepository {
  final DevicesApi _api;
  DevicesRepositoryImpl(this._api);

  @override
  Future<Result<(List<DeviceItem>, int, int, int)>> getDevices({
    required int page,
    required int limit,
    String? search,
  }) async {
    try {
      final res = await _api.getDevices(
        page: page,
        limit: limit,
        search: search,
      );
      // Handle nested response structure: {data: {list: [...], currentPage: 1, ...}}
      final responseData = res.data as Map<String, dynamic>;
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;
      final dto = DevicesResponseDto.fromJson(data);
      final items = dto.list
          .map(
            (e) => DeviceItem(
              id: e.id,
              deviceName: e.deviceName,
              ssidRouter: e.ssidRouter,
              routerStatus: e.routerStatus,
              vpnStatus: e.vpnStatus,
            ),
          )
          .toList();
      return Result.ok((
        items,
        dto.currentPage,
        dto.totalPages,
        dto.totalItems,
      ));
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }

  @override
  Future<Result<DeviceDetail>> getDeviceDetail(String deviceId) async {
    try {
      final res = await _api.getDeviceDetail(deviceId);
      // Handle nested response structure: {data: {...}}
      final responseData = res.data as Map<String, dynamic>;
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;
      final dto = DeviceDetailDto.fromJson(data);
      final detail = DeviceDetail(
        ipWanRouter: dto.ipWanRouter,
        ipLanRouter: dto.ipLanRouter,
        firmwareRouter: dto.firmwareRouter,
        keyName: dto.keyName,
        startDate: dto.startDate,
        endDate: dto.endDate,
        dataUsage: dto.dataUsage,
        totalDataUsage: dto.totalDataUsage,
        keyId: dto.keyId,
        locationId: dto.locationId,
      );
      return Result.ok(detail);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }

  @override
  Future<Result<void>> addDevice({
    required String deviceSerialNumber,
    required String deviceMacAddress,
    required String deviceAlias,
  }) async {
    try {
      await _api.addDevice(
        deviceSerialNumber: deviceSerialNumber,
        deviceMacAddress: deviceMacAddress,
        deviceAlias: deviceAlias,
      );
      return Result.ok(null);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }

  @override
  Future<Result<void>> turnOnVpn(String deviceId) async {
    try {
      await _api.turnOnVpn(deviceId);
      return Result.ok(null);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }

  @override
  Future<Result<void>> turnOffVpn(String deviceId) async {
    try {
      await _api.turnOffVpn(deviceId);
      return Result.ok(null);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }
}
