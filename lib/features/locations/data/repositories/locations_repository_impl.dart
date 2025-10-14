import '../../../../core/error/result.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/locations_repository.dart';
import '../datasources/locations_api.dart';
import '../models/location_dto.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsApi _api;
  LocationsRepositoryImpl(this._api);

  @override
  Future<Result<LocationsResponse>> getLocations({
    required String deviceId,
    String? search,
  }) async {
    try {
      final res = await _api.getLocations(deviceId: deviceId, search: search);
      final dto = LocationsResponseDto.fromJson(
        res.data as Map<String, dynamic>,
      );

      final response = LocationsResponse(
        currentLocation: Location(
          id: dto.currentLocation.id,
          location: dto.currentLocation.location,
          imageUrl: dto.currentLocation.imageUrl,
          uptime: dto.currentLocation.uptime,
          serverId: dto.currentLocation.serverId,
          serverStatus: dto.currentLocation.serverStatus,
          name: dto.currentLocation.name,
          accessedMinusAgo: dto.currentLocation.accessedMinusAgo,
          keyIncremental: dto.currentLocation.keyIncremental,
          monitorIds: dto.currentLocation.monitorIds,
          quantityKeys: dto.currentLocation.quantityKeys,
          keyId: dto.currentLocation.keyId,
          isDisabled: dto.currentLocation.isDisabled,
        ),
        recentLocations: dto.recentLocations
            .map(
              (e) => Location(
                id: e.id,
                location: e.location,
                imageUrl: e.imageUrl,
                uptime: e.uptime,
                serverId: e.serverId,
                serverStatus: e.serverStatus,
                name: e.name,
                accessedMinusAgo: e.accessedMinusAgo,
                keyIncremental: e.keyIncremental,
                monitorIds: e.monitorIds,
                quantityKeys: e.quantityKeys,
                keyId: e.keyId,
                isDisabled: e.isDisabled,
              ),
            )
            .toList(),
        allLocations: dto.allLocations
            .map(
              (e) => Location(
                id: e.id,
                location: e.location,
                imageUrl: e.imageUrl,
                uptime: e.uptime,
                serverId: e.serverId,
                serverStatus: e.serverStatus,
                name: e.name,
                accessedMinusAgo: e.accessedMinusAgo,
                keyIncremental: e.keyIncremental,
                monitorIds: e.monitorIds,
                quantityKeys: e.quantityKeys,
                keyId: e.keyId,
                isDisabled: e.isDisabled,
              ),
            )
            .toList(),
      );

      return Result.ok(response);
    } catch (e) {
      return Result.err(ResultMapper.mapGenericError(e));
    }
  }
}
