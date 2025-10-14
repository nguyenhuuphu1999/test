class DeviceItem {
  final String id;
  final String deviceName;
  final String ssidRouter;
  final String routerStatus; // ONLINE/OFFLINE
  final String vpnStatus; // ENABLED/DISABLED

  const DeviceItem({
    required this.id,
    required this.deviceName,
    required this.ssidRouter,
    required this.routerStatus,
    required this.vpnStatus,
  });
}

class DeviceDetail {
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

  const DeviceDetail({
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
}
