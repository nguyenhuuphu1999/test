class DeviceDto {
  final String id;
  final String deviceName;
  final String ssidRouter;
  final String routerStatus;
  final String vpnStatus;

  DeviceDto({
    required this.id,
    required this.deviceName,
    required this.ssidRouter,
    required this.routerStatus,
    required this.vpnStatus,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) => DeviceDto(
    id: json['id']?.toString() ?? '',
    deviceName: json['deviceName']?.toString() ?? '',
    ssidRouter: json['ssidRouter']?.toString() ?? '',
    routerStatus: json['routerStatus']?.toString() ?? '',
    vpnStatus: json['vpnStatus']?.toString() ?? '',
  );
}

class DevicesResponseDto {
  final List<DeviceDto> list;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  DevicesResponseDto({
    required this.list,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory DevicesResponseDto.fromJson(Map<String, dynamic> json) =>
      DevicesResponseDto(
        list: (json['list'] as List<dynamic>? ?? [])
            .map((e) => DeviceDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        currentPage: json['currentPage'] is int
            ? json['currentPage'] as int
            : int.tryParse(json['currentPage']?.toString() ?? '1') ?? 1,
        totalPages: json['totalPages'] is int
            ? json['totalPages'] as int
            : int.tryParse(json['totalPages']?.toString() ?? '1') ?? 1,
        totalItems: json['totalItems'] is int
            ? json['totalItems'] as int
            : int.tryParse(json['totalItems']?.toString() ?? '0') ?? 0,
      );
}

class DeviceDetailDto {
  final String ipWanRouter;
  final String ipLanRouter;
  final String firmwareRouter;
  final String keyName;
  final DateTime startDate;
  final DateTime endDate;
  final int dataUsage;
  final int totalDataUsage;
  final String keyId;
  final String locationId;

  DeviceDetailDto({
    required this.ipWanRouter,
    required this.ipLanRouter,
    required this.firmwareRouter,
    required this.keyName,
    required this.startDate,
    required this.endDate,
    required this.dataUsage,
    required this.totalDataUsage,
    required this.keyId,
    required this.locationId,
  });

  factory DeviceDetailDto.fromJson(Map<String, dynamic> json) =>
      DeviceDetailDto(
        ipWanRouter: json['ipWanRouter']?.toString() ?? '',
        ipLanRouter: json['ipLanRouter']?.toString() ?? '',
        firmwareRouter: json['firmwareRouter']?.toString() ?? '',
        keyName: json['keyName']?.toString() ?? '',
        startDate:
            DateTime.tryParse(json['startDate']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        endDate:
            DateTime.tryParse(json['endDate']?.toString() ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        dataUsage: json['dataUsage'] is int
            ? json['dataUsage'] as int
            : int.tryParse(json['dataUsage']?.toString() ?? '0') ?? 0,
        totalDataUsage: json['totalDataUsage'] is int
            ? json['totalDataUsage'] as int
            : int.tryParse(json['totalDataUsage']?.toString() ?? '0') ?? 0,
        keyId: json['keyId']?.toString() ?? '',
        locationId: json['locationId']?.toString() ?? '',
      );
}
