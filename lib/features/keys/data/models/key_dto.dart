import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/key.dart';

part 'key_dto.freezed.dart';
part 'key_dto.g.dart';

@freezed
class KeyDto with _$KeyDto {
  const factory KeyDto({
    required String id,
    String? keyId,
    required String name,
    int? port,
    String? method,
    required String accessUrl,
    String? password,
    bool? enable,
    bool? enableByAdmin,
    int? status,
    int? dataLimit,
    int? dataUsage,
    int? dataUsageToday,
    int? dataUsageYesterday,
    double? usagePercentage,
    ServerDto? server,
    DateTime? createdAt,
    DateTime? endDate,
    int? daysRemaining,
    bool? isUserNormal,
    MigrationDto? migration,
    List<RecentUsageDto>? recentUsage,
    UsageStatsDto? usageStats,
  }) = _KeyDto;

  factory KeyDto.fromJson(Map<String, dynamic> json) => _$KeyDtoFromJson(json);
}

extension KeyDtoX on KeyDto {
  Key toEntity() {
    return Key(
      id: id,
      keyId: keyId ?? '',
      name: name,
      password: password ?? '',
      port: port ?? 443,
      method: method ?? 'chacha20-ietf-poly1305',
      accessUrl: accessUrl,
      enable: enable ?? true,
      enableByAdmin: enableByAdmin ?? true,
      dataLimit: dataLimit ?? 0,
      dataUsage: dataUsage ?? 0,
      dataExpand: dataLimit ?? 0, // Use dataLimit as dataExpand for now
      serverLocation: server?.location ?? 'Unknown',
      serverName: server?.name ?? 'Unknown Server',
      account: '', // Not available in new API
      startDate: createdAt ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 30)),
      status: status ?? 1,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: createdAt ?? DateTime.now(), // Use createdAt as updatedAt
      ossId: null, // Not available in new API
      fileName: null, // Not available in new API
      prefix: null, // Not available in new API
    );
  }
}

@freezed
class ServerDto with _$ServerDto {
  const factory ServerDto({
    required String id,
    required String name,
    String? location,
    String? ip,
    String? country,
  }) = _ServerDto;

  factory ServerDto.fromJson(Map<String, dynamic> json) =>
      _$ServerDtoFromJson(json);
}

@freezed
class MigrationDto with _$MigrationDto {
  const factory MigrationDto({
    DateTime? migrateDate,
    int? counterMigrate,
    int? counterMigrateV2,
  }) = _MigrationDto;

  factory MigrationDto.fromJson(Map<String, dynamic> json) =>
      _$MigrationDtoFromJson(json);
}

@freezed
class RecentUsageDto with _$RecentUsageDto {
  const factory RecentUsageDto({required String date, required double usage}) =
      _RecentUsageDto;

  factory RecentUsageDto.fromJson(Map<String, dynamic> json) =>
      _$RecentUsageDtoFromJson(json);
}

@freezed
class UsageStatsDto with _$UsageStatsDto {
  const factory UsageStatsDto({
    required double total,
    required double average,
    required double peak,
    String? peakDate,
  }) = _UsageStatsDto;

  factory UsageStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UsageStatsDtoFromJson(json);
}
