class LocationDto {
  final String id;
  final String location;
  final String imageUrl;
  final double uptime;
  final String serverId;
  final int serverStatus;
  final String name;
  final int accessedMinusAgo;
  final int keyIncremental;
  final List<String> monitorIds;
  final int quantityKeys;
  final String keyId;
  final bool isDisabled;

  LocationDto({
    required this.id,
    required this.location,
    required this.imageUrl,
    required this.uptime,
    required this.serverId,
    required this.serverStatus,
    required this.name,
    required this.accessedMinusAgo,
    required this.keyIncremental,
    required this.monitorIds,
    required this.quantityKeys,
    required this.keyId,
    required this.isDisabled,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) => LocationDto(
    id: json['id']?.toString() ?? '',
    location: json['location']?.toString() ?? '',
    imageUrl: json['imageUrl']?.toString() ?? '',
    uptime: (json['uptime'] is num) ? (json['uptime'] as num).toDouble() : 0.0,
    serverId: json['serverId']?.toString() ?? '',
    serverStatus: json['serverStatus'] is int ? json['serverStatus'] as int : 0,
    name: json['name']?.toString() ?? '',
    accessedMinusAgo: json['accessedMinusAgo'] is int
        ? json['accessedMinusAgo'] as int
        : 0,
    keyIncremental: json['keyIncremental'] is int
        ? json['keyIncremental'] as int
        : 0,
    monitorIds: (json['monitorIds'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    quantityKeys: json['quantityKeys'] is int ? json['quantityKeys'] as int : 0,
    keyId: json['keyId']?.toString() ?? '',
    isDisabled: json['isDisabled'] is bool ? json['isDisabled'] as bool : false,
  );
}

class LocationsResponseDto {
  final LocationDto currentLocation;
  final List<LocationDto> recentLocations;
  final List<LocationDto> allLocations;

  LocationsResponseDto({
    required this.currentLocation,
    required this.recentLocations,
    required this.allLocations,
  });

  factory LocationsResponseDto.fromJson(Map<String, dynamic> json) =>
      LocationsResponseDto(
        currentLocation: LocationDto.fromJson(
          json['currentLocation'] as Map<String, dynamic>,
        ),
        recentLocations: (json['recentLocations'] as List<dynamic>? ?? [])
            .map((e) => LocationDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        allLocations: (json['allLocations'] as List<dynamic>? ?? [])
            .map((e) => LocationDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
