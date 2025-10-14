// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeyDtoImpl _$$KeyDtoImplFromJson(Map<String, dynamic> json) => _$KeyDtoImpl(
  id: json['id'] as String,
  keyId: json['keyId'] as String?,
  name: json['name'] as String,
  port: (json['port'] as num?)?.toInt(),
  method: json['method'] as String?,
  accessUrl: json['accessUrl'] as String,
  password: json['password'] as String?,
  enable: json['enable'] as bool?,
  enableByAdmin: json['enableByAdmin'] as bool?,
  status: (json['status'] as num?)?.toInt(),
  dataLimit: (json['dataLimit'] as num?)?.toInt(),
  dataUsage: (json['dataUsage'] as num?)?.toInt(),
  dataUsageToday: (json['dataUsageToday'] as num?)?.toInt(),
  dataUsageYesterday: (json['dataUsageYesterday'] as num?)?.toInt(),
  usagePercentage: (json['usagePercentage'] as num?)?.toDouble(),
  server: json['server'] == null
      ? null
      : ServerDto.fromJson(json['server'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
  isUserNormal: json['isUserNormal'] as bool?,
  migration: json['migration'] == null
      ? null
      : MigrationDto.fromJson(json['migration'] as Map<String, dynamic>),
  recentUsage: (json['recentUsage'] as List<dynamic>?)
      ?.map((e) => RecentUsageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  usageStats: json['usageStats'] == null
      ? null
      : UsageStatsDto.fromJson(json['usageStats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$KeyDtoImplToJson(_$KeyDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keyId': instance.keyId,
      'name': instance.name,
      'port': instance.port,
      'method': instance.method,
      'accessUrl': instance.accessUrl,
      'password': instance.password,
      'enable': instance.enable,
      'enableByAdmin': instance.enableByAdmin,
      'status': instance.status,
      'dataLimit': instance.dataLimit,
      'dataUsage': instance.dataUsage,
      'dataUsageToday': instance.dataUsageToday,
      'dataUsageYesterday': instance.dataUsageYesterday,
      'usagePercentage': instance.usagePercentage,
      'server': instance.server,
      'createdAt': instance.createdAt?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'daysRemaining': instance.daysRemaining,
      'isUserNormal': instance.isUserNormal,
      'migration': instance.migration,
      'recentUsage': instance.recentUsage,
      'usageStats': instance.usageStats,
    };

_$ServerDtoImpl _$$ServerDtoImplFromJson(Map<String, dynamic> json) =>
    _$ServerDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      ip: json['ip'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$ServerDtoImplToJson(_$ServerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'ip': instance.ip,
      'country': instance.country,
    };

_$MigrationDtoImpl _$$MigrationDtoImplFromJson(Map<String, dynamic> json) =>
    _$MigrationDtoImpl(
      migrateDate: json['migrateDate'] == null
          ? null
          : DateTime.parse(json['migrateDate'] as String),
      counterMigrate: (json['counterMigrate'] as num?)?.toInt(),
      counterMigrateV2: (json['counterMigrateV2'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MigrationDtoImplToJson(_$MigrationDtoImpl instance) =>
    <String, dynamic>{
      'migrateDate': instance.migrateDate?.toIso8601String(),
      'counterMigrate': instance.counterMigrate,
      'counterMigrateV2': instance.counterMigrateV2,
    };

_$RecentUsageDtoImpl _$$RecentUsageDtoImplFromJson(Map<String, dynamic> json) =>
    _$RecentUsageDtoImpl(
      date: json['date'] as String,
      usage: (json['usage'] as num).toDouble(),
    );

Map<String, dynamic> _$$RecentUsageDtoImplToJson(
  _$RecentUsageDtoImpl instance,
) => <String, dynamic>{'date': instance.date, 'usage': instance.usage};

_$UsageStatsDtoImpl _$$UsageStatsDtoImplFromJson(Map<String, dynamic> json) =>
    _$UsageStatsDtoImpl(
      total: (json['total'] as num).toDouble(),
      average: (json['average'] as num).toDouble(),
      peak: (json['peak'] as num).toDouble(),
      peakDate: json['peakDate'] as String?,
    );

Map<String, dynamic> _$$UsageStatsDtoImplToJson(_$UsageStatsDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'average': instance.average,
      'peak': instance.peak,
      'peakDate': instance.peakDate,
    };
