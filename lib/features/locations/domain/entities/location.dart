import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required String id,
    required String location,
    required String imageUrl,
    required double uptime,
    required String serverId,
    required int serverStatus,
    required String name,
    required int accessedMinusAgo,
    required int keyIncremental,
    required List<String> monitorIds,
    required int quantityKeys,
    required String keyId,
    required bool isDisabled,
  }) = _Location;
}

@freezed
class LocationsResponse with _$LocationsResponse {
  const factory LocationsResponse({
    required Location currentLocation,
    required List<Location> recentLocations,
    required List<Location> allLocations,
  }) = _LocationsResponse;
}
