class KeyDetails {
  final String name;
  final String packageName;
  final String startDate;
  final String endDate;
  final String serverLocation;
  final String outlineLink;
  final String alternateLink;
  final String quotaText;
  final int remainDays;
  final bool expired;

  const KeyDetails({
    required this.name,
    required this.packageName,
    required this.startDate,
    required this.endDate,
    required this.serverLocation,
    required this.outlineLink,
    required this.alternateLink,
    required this.quotaText,
    required this.remainDays,
    this.expired = false,
  });

  factory KeyDetails.fromKeyItem(
    String name,
    String quota,
    int days, {
    bool expired = false,
  }) {
    return KeyDetails(
      name: name,
      packageName: 'M-150',
      startDate: '2024-04-11 12:25',
      endDate: '2024-04-11',
      serverLocation: 'US',
      outlineLink: 'Main link',
      alternateLink: 'Alternate link',
      quotaText: quota,
      remainDays: days,
      expired: expired,
    );
  }
}
