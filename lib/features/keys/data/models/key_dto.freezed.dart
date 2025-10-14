// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KeyDto _$KeyDtoFromJson(Map<String, dynamic> json) {
  return _KeyDto.fromJson(json);
}

/// @nodoc
mixin _$KeyDto {
  String get id => throw _privateConstructorUsedError;
  String? get keyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get port => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  String get accessUrl => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  bool? get enable => throw _privateConstructorUsedError;
  bool? get enableByAdmin => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  int? get dataLimit => throw _privateConstructorUsedError;
  int? get dataUsage => throw _privateConstructorUsedError;
  int? get dataUsageToday => throw _privateConstructorUsedError;
  int? get dataUsageYesterday => throw _privateConstructorUsedError;
  double? get usagePercentage => throw _privateConstructorUsedError;
  ServerDto? get server => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get daysRemaining => throw _privateConstructorUsedError;
  bool? get isUserNormal => throw _privateConstructorUsedError;
  MigrationDto? get migration => throw _privateConstructorUsedError;
  List<RecentUsageDto>? get recentUsage => throw _privateConstructorUsedError;
  UsageStatsDto? get usageStats => throw _privateConstructorUsedError;

  /// Serializes this KeyDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeyDtoCopyWith<KeyDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyDtoCopyWith<$Res> {
  factory $KeyDtoCopyWith(KeyDto value, $Res Function(KeyDto) then) =
      _$KeyDtoCopyWithImpl<$Res, KeyDto>;
  @useResult
  $Res call({
    String id,
    String? keyId,
    String name,
    int? port,
    String? method,
    String accessUrl,
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
  });

  $ServerDtoCopyWith<$Res>? get server;
  $MigrationDtoCopyWith<$Res>? get migration;
  $UsageStatsDtoCopyWith<$Res>? get usageStats;
}

/// @nodoc
class _$KeyDtoCopyWithImpl<$Res, $Val extends KeyDto>
    implements $KeyDtoCopyWith<$Res> {
  _$KeyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyId = freezed,
    Object? name = null,
    Object? port = freezed,
    Object? method = freezed,
    Object? accessUrl = null,
    Object? password = freezed,
    Object? enable = freezed,
    Object? enableByAdmin = freezed,
    Object? status = freezed,
    Object? dataLimit = freezed,
    Object? dataUsage = freezed,
    Object? dataUsageToday = freezed,
    Object? dataUsageYesterday = freezed,
    Object? usagePercentage = freezed,
    Object? server = freezed,
    Object? createdAt = freezed,
    Object? endDate = freezed,
    Object? daysRemaining = freezed,
    Object? isUserNormal = freezed,
    Object? migration = freezed,
    Object? recentUsage = freezed,
    Object? usageStats = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            keyId: freezed == keyId
                ? _value.keyId
                : keyId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            port: freezed == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int?,
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String?,
            accessUrl: null == accessUrl
                ? _value.accessUrl
                : accessUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            password: freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String?,
            enable: freezed == enable
                ? _value.enable
                : enable // ignore: cast_nullable_to_non_nullable
                      as bool?,
            enableByAdmin: freezed == enableByAdmin
                ? _value.enableByAdmin
                : enableByAdmin // ignore: cast_nullable_to_non_nullable
                      as bool?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataLimit: freezed == dataLimit
                ? _value.dataLimit
                : dataLimit // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataUsage: freezed == dataUsage
                ? _value.dataUsage
                : dataUsage // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataUsageToday: freezed == dataUsageToday
                ? _value.dataUsageToday
                : dataUsageToday // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataUsageYesterday: freezed == dataUsageYesterday
                ? _value.dataUsageYesterday
                : dataUsageYesterday // ignore: cast_nullable_to_non_nullable
                      as int?,
            usagePercentage: freezed == usagePercentage
                ? _value.usagePercentage
                : usagePercentage // ignore: cast_nullable_to_non_nullable
                      as double?,
            server: freezed == server
                ? _value.server
                : server // ignore: cast_nullable_to_non_nullable
                      as ServerDto?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            daysRemaining: freezed == daysRemaining
                ? _value.daysRemaining
                : daysRemaining // ignore: cast_nullable_to_non_nullable
                      as int?,
            isUserNormal: freezed == isUserNormal
                ? _value.isUserNormal
                : isUserNormal // ignore: cast_nullable_to_non_nullable
                      as bool?,
            migration: freezed == migration
                ? _value.migration
                : migration // ignore: cast_nullable_to_non_nullable
                      as MigrationDto?,
            recentUsage: freezed == recentUsage
                ? _value.recentUsage
                : recentUsage // ignore: cast_nullable_to_non_nullable
                      as List<RecentUsageDto>?,
            usageStats: freezed == usageStats
                ? _value.usageStats
                : usageStats // ignore: cast_nullable_to_non_nullable
                      as UsageStatsDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServerDtoCopyWith<$Res>? get server {
    if (_value.server == null) {
      return null;
    }

    return $ServerDtoCopyWith<$Res>(_value.server!, (value) {
      return _then(_value.copyWith(server: value) as $Val);
    });
  }

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MigrationDtoCopyWith<$Res>? get migration {
    if (_value.migration == null) {
      return null;
    }

    return $MigrationDtoCopyWith<$Res>(_value.migration!, (value) {
      return _then(_value.copyWith(migration: value) as $Val);
    });
  }

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageStatsDtoCopyWith<$Res>? get usageStats {
    if (_value.usageStats == null) {
      return null;
    }

    return $UsageStatsDtoCopyWith<$Res>(_value.usageStats!, (value) {
      return _then(_value.copyWith(usageStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KeyDtoImplCopyWith<$Res> implements $KeyDtoCopyWith<$Res> {
  factory _$$KeyDtoImplCopyWith(
    _$KeyDtoImpl value,
    $Res Function(_$KeyDtoImpl) then,
  ) = __$$KeyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? keyId,
    String name,
    int? port,
    String? method,
    String accessUrl,
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
  });

  @override
  $ServerDtoCopyWith<$Res>? get server;
  @override
  $MigrationDtoCopyWith<$Res>? get migration;
  @override
  $UsageStatsDtoCopyWith<$Res>? get usageStats;
}

/// @nodoc
class __$$KeyDtoImplCopyWithImpl<$Res>
    extends _$KeyDtoCopyWithImpl<$Res, _$KeyDtoImpl>
    implements _$$KeyDtoImplCopyWith<$Res> {
  __$$KeyDtoImplCopyWithImpl(
    _$KeyDtoImpl _value,
    $Res Function(_$KeyDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? keyId = freezed,
    Object? name = null,
    Object? port = freezed,
    Object? method = freezed,
    Object? accessUrl = null,
    Object? password = freezed,
    Object? enable = freezed,
    Object? enableByAdmin = freezed,
    Object? status = freezed,
    Object? dataLimit = freezed,
    Object? dataUsage = freezed,
    Object? dataUsageToday = freezed,
    Object? dataUsageYesterday = freezed,
    Object? usagePercentage = freezed,
    Object? server = freezed,
    Object? createdAt = freezed,
    Object? endDate = freezed,
    Object? daysRemaining = freezed,
    Object? isUserNormal = freezed,
    Object? migration = freezed,
    Object? recentUsage = freezed,
    Object? usageStats = freezed,
  }) {
    return _then(
      _$KeyDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        keyId: freezed == keyId
            ? _value.keyId
            : keyId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        port: freezed == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int?,
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String?,
        accessUrl: null == accessUrl
            ? _value.accessUrl
            : accessUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        password: freezed == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String?,
        enable: freezed == enable
            ? _value.enable
            : enable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enableByAdmin: freezed == enableByAdmin
            ? _value.enableByAdmin
            : enableByAdmin // ignore: cast_nullable_to_non_nullable
                  as bool?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataLimit: freezed == dataLimit
            ? _value.dataLimit
            : dataLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataUsage: freezed == dataUsage
            ? _value.dataUsage
            : dataUsage // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataUsageToday: freezed == dataUsageToday
            ? _value.dataUsageToday
            : dataUsageToday // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataUsageYesterday: freezed == dataUsageYesterday
            ? _value.dataUsageYesterday
            : dataUsageYesterday // ignore: cast_nullable_to_non_nullable
                  as int?,
        usagePercentage: freezed == usagePercentage
            ? _value.usagePercentage
            : usagePercentage // ignore: cast_nullable_to_non_nullable
                  as double?,
        server: freezed == server
            ? _value.server
            : server // ignore: cast_nullable_to_non_nullable
                  as ServerDto?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        daysRemaining: freezed == daysRemaining
            ? _value.daysRemaining
            : daysRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
        isUserNormal: freezed == isUserNormal
            ? _value.isUserNormal
            : isUserNormal // ignore: cast_nullable_to_non_nullable
                  as bool?,
        migration: freezed == migration
            ? _value.migration
            : migration // ignore: cast_nullable_to_non_nullable
                  as MigrationDto?,
        recentUsage: freezed == recentUsage
            ? _value._recentUsage
            : recentUsage // ignore: cast_nullable_to_non_nullable
                  as List<RecentUsageDto>?,
        usageStats: freezed == usageStats
            ? _value.usageStats
            : usageStats // ignore: cast_nullable_to_non_nullable
                  as UsageStatsDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeyDtoImpl implements _KeyDto {
  const _$KeyDtoImpl({
    required this.id,
    this.keyId,
    required this.name,
    this.port,
    this.method,
    required this.accessUrl,
    this.password,
    this.enable,
    this.enableByAdmin,
    this.status,
    this.dataLimit,
    this.dataUsage,
    this.dataUsageToday,
    this.dataUsageYesterday,
    this.usagePercentage,
    this.server,
    this.createdAt,
    this.endDate,
    this.daysRemaining,
    this.isUserNormal,
    this.migration,
    final List<RecentUsageDto>? recentUsage,
    this.usageStats,
  }) : _recentUsage = recentUsage;

  factory _$KeyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeyDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String? keyId;
  @override
  final String name;
  @override
  final int? port;
  @override
  final String? method;
  @override
  final String accessUrl;
  @override
  final String? password;
  @override
  final bool? enable;
  @override
  final bool? enableByAdmin;
  @override
  final int? status;
  @override
  final int? dataLimit;
  @override
  final int? dataUsage;
  @override
  final int? dataUsageToday;
  @override
  final int? dataUsageYesterday;
  @override
  final double? usagePercentage;
  @override
  final ServerDto? server;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? endDate;
  @override
  final int? daysRemaining;
  @override
  final bool? isUserNormal;
  @override
  final MigrationDto? migration;
  final List<RecentUsageDto>? _recentUsage;
  @override
  List<RecentUsageDto>? get recentUsage {
    final value = _recentUsage;
    if (value == null) return null;
    if (_recentUsage is EqualUnmodifiableListView) return _recentUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final UsageStatsDto? usageStats;

  @override
  String toString() {
    return 'KeyDto(id: $id, keyId: $keyId, name: $name, port: $port, method: $method, accessUrl: $accessUrl, password: $password, enable: $enable, enableByAdmin: $enableByAdmin, status: $status, dataLimit: $dataLimit, dataUsage: $dataUsage, dataUsageToday: $dataUsageToday, dataUsageYesterday: $dataUsageYesterday, usagePercentage: $usagePercentage, server: $server, createdAt: $createdAt, endDate: $endDate, daysRemaining: $daysRemaining, isUserNormal: $isUserNormal, migration: $migration, recentUsage: $recentUsage, usageStats: $usageStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.accessUrl, accessUrl) ||
                other.accessUrl == accessUrl) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.enable, enable) || other.enable == enable) &&
            (identical(other.enableByAdmin, enableByAdmin) ||
                other.enableByAdmin == enableByAdmin) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataLimit, dataLimit) ||
                other.dataLimit == dataLimit) &&
            (identical(other.dataUsage, dataUsage) ||
                other.dataUsage == dataUsage) &&
            (identical(other.dataUsageToday, dataUsageToday) ||
                other.dataUsageToday == dataUsageToday) &&
            (identical(other.dataUsageYesterday, dataUsageYesterday) ||
                other.dataUsageYesterday == dataUsageYesterday) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage) &&
            (identical(other.server, server) || other.server == server) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.daysRemaining, daysRemaining) ||
                other.daysRemaining == daysRemaining) &&
            (identical(other.isUserNormal, isUserNormal) ||
                other.isUserNormal == isUserNormal) &&
            (identical(other.migration, migration) ||
                other.migration == migration) &&
            const DeepCollectionEquality().equals(
              other._recentUsage,
              _recentUsage,
            ) &&
            (identical(other.usageStats, usageStats) ||
                other.usageStats == usageStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    keyId,
    name,
    port,
    method,
    accessUrl,
    password,
    enable,
    enableByAdmin,
    status,
    dataLimit,
    dataUsage,
    dataUsageToday,
    dataUsageYesterday,
    usagePercentage,
    server,
    createdAt,
    endDate,
    daysRemaining,
    isUserNormal,
    migration,
    const DeepCollectionEquality().hash(_recentUsage),
    usageStats,
  ]);

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyDtoImplCopyWith<_$KeyDtoImpl> get copyWith =>
      __$$KeyDtoImplCopyWithImpl<_$KeyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeyDtoImplToJson(this);
  }
}

abstract class _KeyDto implements KeyDto {
  const factory _KeyDto({
    required final String id,
    final String? keyId,
    required final String name,
    final int? port,
    final String? method,
    required final String accessUrl,
    final String? password,
    final bool? enable,
    final bool? enableByAdmin,
    final int? status,
    final int? dataLimit,
    final int? dataUsage,
    final int? dataUsageToday,
    final int? dataUsageYesterday,
    final double? usagePercentage,
    final ServerDto? server,
    final DateTime? createdAt,
    final DateTime? endDate,
    final int? daysRemaining,
    final bool? isUserNormal,
    final MigrationDto? migration,
    final List<RecentUsageDto>? recentUsage,
    final UsageStatsDto? usageStats,
  }) = _$KeyDtoImpl;

  factory _KeyDto.fromJson(Map<String, dynamic> json) = _$KeyDtoImpl.fromJson;

  @override
  String get id;
  @override
  String? get keyId;
  @override
  String get name;
  @override
  int? get port;
  @override
  String? get method;
  @override
  String get accessUrl;
  @override
  String? get password;
  @override
  bool? get enable;
  @override
  bool? get enableByAdmin;
  @override
  int? get status;
  @override
  int? get dataLimit;
  @override
  int? get dataUsage;
  @override
  int? get dataUsageToday;
  @override
  int? get dataUsageYesterday;
  @override
  double? get usagePercentage;
  @override
  ServerDto? get server;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get endDate;
  @override
  int? get daysRemaining;
  @override
  bool? get isUserNormal;
  @override
  MigrationDto? get migration;
  @override
  List<RecentUsageDto>? get recentUsage;
  @override
  UsageStatsDto? get usageStats;

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyDtoImplCopyWith<_$KeyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServerDto _$ServerDtoFromJson(Map<String, dynamic> json) {
  return _ServerDto.fromJson(json);
}

/// @nodoc
mixin _$ServerDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get ip => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  /// Serializes this ServerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerDtoCopyWith<ServerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerDtoCopyWith<$Res> {
  factory $ServerDtoCopyWith(ServerDto value, $Res Function(ServerDto) then) =
      _$ServerDtoCopyWithImpl<$Res, ServerDto>;
  @useResult
  $Res call({
    String id,
    String name,
    String? location,
    String? ip,
    String? country,
  });
}

/// @nodoc
class _$ServerDtoCopyWithImpl<$Res, $Val extends ServerDto>
    implements $ServerDtoCopyWith<$Res> {
  _$ServerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
    Object? ip = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            ip: freezed == ip
                ? _value.ip
                : ip // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerDtoImplCopyWith<$Res>
    implements $ServerDtoCopyWith<$Res> {
  factory _$$ServerDtoImplCopyWith(
    _$ServerDtoImpl value,
    $Res Function(_$ServerDtoImpl) then,
  ) = __$$ServerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? location,
    String? ip,
    String? country,
  });
}

/// @nodoc
class __$$ServerDtoImplCopyWithImpl<$Res>
    extends _$ServerDtoCopyWithImpl<$Res, _$ServerDtoImpl>
    implements _$$ServerDtoImplCopyWith<$Res> {
  __$$ServerDtoImplCopyWithImpl(
    _$ServerDtoImpl _value,
    $Res Function(_$ServerDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = freezed,
    Object? ip = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _$ServerDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        ip: freezed == ip
            ? _value.ip
            : ip // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerDtoImpl implements _ServerDto {
  const _$ServerDtoImpl({
    required this.id,
    required this.name,
    this.location,
    this.ip,
    this.country,
  });

  factory _$ServerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? location;
  @override
  final String? ip;
  @override
  final String? country;

  @override
  String toString() {
    return 'ServerDto(id: $id, name: $name, location: $location, ip: $ip, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, location, ip, country);

  /// Create a copy of ServerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerDtoImplCopyWith<_$ServerDtoImpl> get copyWith =>
      __$$ServerDtoImplCopyWithImpl<_$ServerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerDtoImplToJson(this);
  }
}

abstract class _ServerDto implements ServerDto {
  const factory _ServerDto({
    required final String id,
    required final String name,
    final String? location,
    final String? ip,
    final String? country,
  }) = _$ServerDtoImpl;

  factory _ServerDto.fromJson(Map<String, dynamic> json) =
      _$ServerDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get location;
  @override
  String? get ip;
  @override
  String? get country;

  /// Create a copy of ServerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerDtoImplCopyWith<_$ServerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MigrationDto _$MigrationDtoFromJson(Map<String, dynamic> json) {
  return _MigrationDto.fromJson(json);
}

/// @nodoc
mixin _$MigrationDto {
  DateTime? get migrateDate => throw _privateConstructorUsedError;
  int? get counterMigrate => throw _privateConstructorUsedError;
  int? get counterMigrateV2 => throw _privateConstructorUsedError;

  /// Serializes this MigrationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MigrationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MigrationDtoCopyWith<MigrationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MigrationDtoCopyWith<$Res> {
  factory $MigrationDtoCopyWith(
    MigrationDto value,
    $Res Function(MigrationDto) then,
  ) = _$MigrationDtoCopyWithImpl<$Res, MigrationDto>;
  @useResult
  $Res call({
    DateTime? migrateDate,
    int? counterMigrate,
    int? counterMigrateV2,
  });
}

/// @nodoc
class _$MigrationDtoCopyWithImpl<$Res, $Val extends MigrationDto>
    implements $MigrationDtoCopyWith<$Res> {
  _$MigrationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MigrationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? migrateDate = freezed,
    Object? counterMigrate = freezed,
    Object? counterMigrateV2 = freezed,
  }) {
    return _then(
      _value.copyWith(
            migrateDate: freezed == migrateDate
                ? _value.migrateDate
                : migrateDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            counterMigrate: freezed == counterMigrate
                ? _value.counterMigrate
                : counterMigrate // ignore: cast_nullable_to_non_nullable
                      as int?,
            counterMigrateV2: freezed == counterMigrateV2
                ? _value.counterMigrateV2
                : counterMigrateV2 // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MigrationDtoImplCopyWith<$Res>
    implements $MigrationDtoCopyWith<$Res> {
  factory _$$MigrationDtoImplCopyWith(
    _$MigrationDtoImpl value,
    $Res Function(_$MigrationDtoImpl) then,
  ) = __$$MigrationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime? migrateDate,
    int? counterMigrate,
    int? counterMigrateV2,
  });
}

/// @nodoc
class __$$MigrationDtoImplCopyWithImpl<$Res>
    extends _$MigrationDtoCopyWithImpl<$Res, _$MigrationDtoImpl>
    implements _$$MigrationDtoImplCopyWith<$Res> {
  __$$MigrationDtoImplCopyWithImpl(
    _$MigrationDtoImpl _value,
    $Res Function(_$MigrationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MigrationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? migrateDate = freezed,
    Object? counterMigrate = freezed,
    Object? counterMigrateV2 = freezed,
  }) {
    return _then(
      _$MigrationDtoImpl(
        migrateDate: freezed == migrateDate
            ? _value.migrateDate
            : migrateDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        counterMigrate: freezed == counterMigrate
            ? _value.counterMigrate
            : counterMigrate // ignore: cast_nullable_to_non_nullable
                  as int?,
        counterMigrateV2: freezed == counterMigrateV2
            ? _value.counterMigrateV2
            : counterMigrateV2 // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MigrationDtoImpl implements _MigrationDto {
  const _$MigrationDtoImpl({
    this.migrateDate,
    this.counterMigrate,
    this.counterMigrateV2,
  });

  factory _$MigrationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MigrationDtoImplFromJson(json);

  @override
  final DateTime? migrateDate;
  @override
  final int? counterMigrate;
  @override
  final int? counterMigrateV2;

  @override
  String toString() {
    return 'MigrationDto(migrateDate: $migrateDate, counterMigrate: $counterMigrate, counterMigrateV2: $counterMigrateV2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MigrationDtoImpl &&
            (identical(other.migrateDate, migrateDate) ||
                other.migrateDate == migrateDate) &&
            (identical(other.counterMigrate, counterMigrate) ||
                other.counterMigrate == counterMigrate) &&
            (identical(other.counterMigrateV2, counterMigrateV2) ||
                other.counterMigrateV2 == counterMigrateV2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, migrateDate, counterMigrate, counterMigrateV2);

  /// Create a copy of MigrationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MigrationDtoImplCopyWith<_$MigrationDtoImpl> get copyWith =>
      __$$MigrationDtoImplCopyWithImpl<_$MigrationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MigrationDtoImplToJson(this);
  }
}

abstract class _MigrationDto implements MigrationDto {
  const factory _MigrationDto({
    final DateTime? migrateDate,
    final int? counterMigrate,
    final int? counterMigrateV2,
  }) = _$MigrationDtoImpl;

  factory _MigrationDto.fromJson(Map<String, dynamic> json) =
      _$MigrationDtoImpl.fromJson;

  @override
  DateTime? get migrateDate;
  @override
  int? get counterMigrate;
  @override
  int? get counterMigrateV2;

  /// Create a copy of MigrationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MigrationDtoImplCopyWith<_$MigrationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentUsageDto _$RecentUsageDtoFromJson(Map<String, dynamic> json) {
  return _RecentUsageDto.fromJson(json);
}

/// @nodoc
mixin _$RecentUsageDto {
  String get date => throw _privateConstructorUsedError;
  double get usage => throw _privateConstructorUsedError;

  /// Serializes this RecentUsageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentUsageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentUsageDtoCopyWith<RecentUsageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentUsageDtoCopyWith<$Res> {
  factory $RecentUsageDtoCopyWith(
    RecentUsageDto value,
    $Res Function(RecentUsageDto) then,
  ) = _$RecentUsageDtoCopyWithImpl<$Res, RecentUsageDto>;
  @useResult
  $Res call({String date, double usage});
}

/// @nodoc
class _$RecentUsageDtoCopyWithImpl<$Res, $Val extends RecentUsageDto>
    implements $RecentUsageDtoCopyWith<$Res> {
  _$RecentUsageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentUsageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? usage = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            usage: null == usage
                ? _value.usage
                : usage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentUsageDtoImplCopyWith<$Res>
    implements $RecentUsageDtoCopyWith<$Res> {
  factory _$$RecentUsageDtoImplCopyWith(
    _$RecentUsageDtoImpl value,
    $Res Function(_$RecentUsageDtoImpl) then,
  ) = __$$RecentUsageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, double usage});
}

/// @nodoc
class __$$RecentUsageDtoImplCopyWithImpl<$Res>
    extends _$RecentUsageDtoCopyWithImpl<$Res, _$RecentUsageDtoImpl>
    implements _$$RecentUsageDtoImplCopyWith<$Res> {
  __$$RecentUsageDtoImplCopyWithImpl(
    _$RecentUsageDtoImpl _value,
    $Res Function(_$RecentUsageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentUsageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? usage = null}) {
    return _then(
      _$RecentUsageDtoImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        usage: null == usage
            ? _value.usage
            : usage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentUsageDtoImpl implements _RecentUsageDto {
  const _$RecentUsageDtoImpl({required this.date, required this.usage});

  factory _$RecentUsageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentUsageDtoImplFromJson(json);

  @override
  final String date;
  @override
  final double usage;

  @override
  String toString() {
    return 'RecentUsageDto(date: $date, usage: $usage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentUsageDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.usage, usage) || other.usage == usage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, usage);

  /// Create a copy of RecentUsageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentUsageDtoImplCopyWith<_$RecentUsageDtoImpl> get copyWith =>
      __$$RecentUsageDtoImplCopyWithImpl<_$RecentUsageDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentUsageDtoImplToJson(this);
  }
}

abstract class _RecentUsageDto implements RecentUsageDto {
  const factory _RecentUsageDto({
    required final String date,
    required final double usage,
  }) = _$RecentUsageDtoImpl;

  factory _RecentUsageDto.fromJson(Map<String, dynamic> json) =
      _$RecentUsageDtoImpl.fromJson;

  @override
  String get date;
  @override
  double get usage;

  /// Create a copy of RecentUsageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentUsageDtoImplCopyWith<_$RecentUsageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsageStatsDto _$UsageStatsDtoFromJson(Map<String, dynamic> json) {
  return _UsageStatsDto.fromJson(json);
}

/// @nodoc
mixin _$UsageStatsDto {
  double get total => throw _privateConstructorUsedError;
  double get average => throw _privateConstructorUsedError;
  double get peak => throw _privateConstructorUsedError;
  String? get peakDate => throw _privateConstructorUsedError;

  /// Serializes this UsageStatsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageStatsDtoCopyWith<UsageStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageStatsDtoCopyWith<$Res> {
  factory $UsageStatsDtoCopyWith(
    UsageStatsDto value,
    $Res Function(UsageStatsDto) then,
  ) = _$UsageStatsDtoCopyWithImpl<$Res, UsageStatsDto>;
  @useResult
  $Res call({double total, double average, double peak, String? peakDate});
}

/// @nodoc
class _$UsageStatsDtoCopyWithImpl<$Res, $Val extends UsageStatsDto>
    implements $UsageStatsDtoCopyWith<$Res> {
  _$UsageStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? average = null,
    Object? peak = null,
    Object? peakDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            average: null == average
                ? _value.average
                : average // ignore: cast_nullable_to_non_nullable
                      as double,
            peak: null == peak
                ? _value.peak
                : peak // ignore: cast_nullable_to_non_nullable
                      as double,
            peakDate: freezed == peakDate
                ? _value.peakDate
                : peakDate // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsageStatsDtoImplCopyWith<$Res>
    implements $UsageStatsDtoCopyWith<$Res> {
  factory _$$UsageStatsDtoImplCopyWith(
    _$UsageStatsDtoImpl value,
    $Res Function(_$UsageStatsDtoImpl) then,
  ) = __$$UsageStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double total, double average, double peak, String? peakDate});
}

/// @nodoc
class __$$UsageStatsDtoImplCopyWithImpl<$Res>
    extends _$UsageStatsDtoCopyWithImpl<$Res, _$UsageStatsDtoImpl>
    implements _$$UsageStatsDtoImplCopyWith<$Res> {
  __$$UsageStatsDtoImplCopyWithImpl(
    _$UsageStatsDtoImpl _value,
    $Res Function(_$UsageStatsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsageStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? average = null,
    Object? peak = null,
    Object? peakDate = freezed,
  }) {
    return _then(
      _$UsageStatsDtoImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        average: null == average
            ? _value.average
            : average // ignore: cast_nullable_to_non_nullable
                  as double,
        peak: null == peak
            ? _value.peak
            : peak // ignore: cast_nullable_to_non_nullable
                  as double,
        peakDate: freezed == peakDate
            ? _value.peakDate
            : peakDate // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageStatsDtoImpl implements _UsageStatsDto {
  const _$UsageStatsDtoImpl({
    required this.total,
    required this.average,
    required this.peak,
    this.peakDate,
  });

  factory _$UsageStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageStatsDtoImplFromJson(json);

  @override
  final double total;
  @override
  final double average;
  @override
  final double peak;
  @override
  final String? peakDate;

  @override
  String toString() {
    return 'UsageStatsDto(total: $total, average: $average, peak: $peak, peakDate: $peakDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageStatsDtoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.peak, peak) || other.peak == peak) &&
            (identical(other.peakDate, peakDate) ||
                other.peakDate == peakDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, average, peak, peakDate);

  /// Create a copy of UsageStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageStatsDtoImplCopyWith<_$UsageStatsDtoImpl> get copyWith =>
      __$$UsageStatsDtoImplCopyWithImpl<_$UsageStatsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageStatsDtoImplToJson(this);
  }
}

abstract class _UsageStatsDto implements UsageStatsDto {
  const factory _UsageStatsDto({
    required final double total,
    required final double average,
    required final double peak,
    final String? peakDate,
  }) = _$UsageStatsDtoImpl;

  factory _UsageStatsDto.fromJson(Map<String, dynamic> json) =
      _$UsageStatsDtoImpl.fromJson;

  @override
  double get total;
  @override
  double get average;
  @override
  double get peak;
  @override
  String? get peakDate;

  /// Create a copy of UsageStatsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageStatsDtoImplCopyWith<_$UsageStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
