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
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get keyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get accessUrl => throw _privateConstructorUsedError;
  bool get enable => throw _privateConstructorUsedError;
  bool get enableByAdmin => throw _privateConstructorUsedError;
  int get dataLimit => throw _privateConstructorUsedError;
  int get dataUsage => throw _privateConstructorUsedError;
  int get dataExpand => throw _privateConstructorUsedError;
  ServerInfo get serverId => throw _privateConstructorUsedError;
  UserInfo get userId => throw _privateConstructorUsedError;
  String get account => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

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
    @JsonKey(name: '_id') String id,
    String keyId,
    String name,
    String password,
    int port,
    String method,
    String accessUrl,
    bool enable,
    bool enableByAdmin,
    int dataLimit,
    int dataUsage,
    int dataExpand,
    ServerInfo serverId,
    UserInfo userId,
    String account,
    String startDate,
    String endDate,
    int status,
    String createdAt,
    String updatedAt,
  });

  $ServerInfoCopyWith<$Res> get serverId;
  $UserInfoCopyWith<$Res> get userId;
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
    Object? keyId = null,
    Object? name = null,
    Object? password = null,
    Object? port = null,
    Object? method = null,
    Object? accessUrl = null,
    Object? enable = null,
    Object? enableByAdmin = null,
    Object? dataLimit = null,
    Object? dataUsage = null,
    Object? dataExpand = null,
    Object? serverId = null,
    Object? userId = null,
    Object? account = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            keyId: null == keyId
                ? _value.keyId
                : keyId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            port: null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                      as int,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            accessUrl: null == accessUrl
                ? _value.accessUrl
                : accessUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            enable: null == enable
                ? _value.enable
                : enable // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableByAdmin: null == enableByAdmin
                ? _value.enableByAdmin
                : enableByAdmin // ignore: cast_nullable_to_non_nullable
                      as bool,
            dataLimit: null == dataLimit
                ? _value.dataLimit
                : dataLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            dataUsage: null == dataUsage
                ? _value.dataUsage
                : dataUsage // ignore: cast_nullable_to_non_nullable
                      as int,
            dataExpand: null == dataExpand
                ? _value.dataExpand
                : dataExpand // ignore: cast_nullable_to_non_nullable
                      as int,
            serverId: null == serverId
                ? _value.serverId
                : serverId // ignore: cast_nullable_to_non_nullable
                      as ServerInfo,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as UserInfo,
            account: null == account
                ? _value.account
                : account // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServerInfoCopyWith<$Res> get serverId {
    return $ServerInfoCopyWith<$Res>(_value.serverId, (value) {
      return _then(_value.copyWith(serverId: value) as $Val);
    });
  }

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<$Res> get userId {
    return $UserInfoCopyWith<$Res>(_value.userId, (value) {
      return _then(_value.copyWith(userId: value) as $Val);
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
    @JsonKey(name: '_id') String id,
    String keyId,
    String name,
    String password,
    int port,
    String method,
    String accessUrl,
    bool enable,
    bool enableByAdmin,
    int dataLimit,
    int dataUsage,
    int dataExpand,
    ServerInfo serverId,
    UserInfo userId,
    String account,
    String startDate,
    String endDate,
    int status,
    String createdAt,
    String updatedAt,
  });

  @override
  $ServerInfoCopyWith<$Res> get serverId;
  @override
  $UserInfoCopyWith<$Res> get userId;
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
    Object? keyId = null,
    Object? name = null,
    Object? password = null,
    Object? port = null,
    Object? method = null,
    Object? accessUrl = null,
    Object? enable = null,
    Object? enableByAdmin = null,
    Object? dataLimit = null,
    Object? dataUsage = null,
    Object? dataExpand = null,
    Object? serverId = null,
    Object? userId = null,
    Object? account = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$KeyDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        keyId: null == keyId
            ? _value.keyId
            : keyId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        port: null == port
            ? _value.port
            : port // ignore: cast_nullable_to_non_nullable
                  as int,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        accessUrl: null == accessUrl
            ? _value.accessUrl
            : accessUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        enable: null == enable
            ? _value.enable
            : enable // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableByAdmin: null == enableByAdmin
            ? _value.enableByAdmin
            : enableByAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
        dataLimit: null == dataLimit
            ? _value.dataLimit
            : dataLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        dataUsage: null == dataUsage
            ? _value.dataUsage
            : dataUsage // ignore: cast_nullable_to_non_nullable
                  as int,
        dataExpand: null == dataExpand
            ? _value.dataExpand
            : dataExpand // ignore: cast_nullable_to_non_nullable
                  as int,
        serverId: null == serverId
            ? _value.serverId
            : serverId // ignore: cast_nullable_to_non_nullable
                  as ServerInfo,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as UserInfo,
        account: null == account
            ? _value.account
            : account // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeyDtoImpl implements _KeyDto {
  const _$KeyDtoImpl({
    @JsonKey(name: '_id') required this.id,
    required this.keyId,
    required this.name,
    required this.password,
    required this.port,
    required this.method,
    required this.accessUrl,
    required this.enable,
    required this.enableByAdmin,
    required this.dataLimit,
    required this.dataUsage,
    required this.dataExpand,
    required this.serverId,
    required this.userId,
    required this.account,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$KeyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeyDtoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String keyId;
  @override
  final String name;
  @override
  final String password;
  @override
  final int port;
  @override
  final String method;
  @override
  final String accessUrl;
  @override
  final bool enable;
  @override
  final bool enableByAdmin;
  @override
  final int dataLimit;
  @override
  final int dataUsage;
  @override
  final int dataExpand;
  @override
  final ServerInfo serverId;
  @override
  final UserInfo userId;
  @override
  final String account;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final int status;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'KeyDto(id: $id, keyId: $keyId, name: $name, password: $password, port: $port, method: $method, accessUrl: $accessUrl, enable: $enable, enableByAdmin: $enableByAdmin, dataLimit: $dataLimit, dataUsage: $dataUsage, dataExpand: $dataExpand, serverId: $serverId, userId: $userId, account: $account, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.accessUrl, accessUrl) ||
                other.accessUrl == accessUrl) &&
            (identical(other.enable, enable) || other.enable == enable) &&
            (identical(other.enableByAdmin, enableByAdmin) ||
                other.enableByAdmin == enableByAdmin) &&
            (identical(other.dataLimit, dataLimit) ||
                other.dataLimit == dataLimit) &&
            (identical(other.dataUsage, dataUsage) ||
                other.dataUsage == dataUsage) &&
            (identical(other.dataExpand, dataExpand) ||
                other.dataExpand == dataExpand) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    keyId,
    name,
    password,
    port,
    method,
    accessUrl,
    enable,
    enableByAdmin,
    dataLimit,
    dataUsage,
    dataExpand,
    serverId,
    userId,
    account,
    startDate,
    endDate,
    status,
    createdAt,
    updatedAt,
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
    @JsonKey(name: '_id') required final String id,
    required final String keyId,
    required final String name,
    required final String password,
    required final int port,
    required final String method,
    required final String accessUrl,
    required final bool enable,
    required final bool enableByAdmin,
    required final int dataLimit,
    required final int dataUsage,
    required final int dataExpand,
    required final ServerInfo serverId,
    required final UserInfo userId,
    required final String account,
    required final String startDate,
    required final String endDate,
    required final int status,
    required final String createdAt,
    required final String updatedAt,
  }) = _$KeyDtoImpl;

  factory _KeyDto.fromJson(Map<String, dynamic> json) = _$KeyDtoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get keyId;
  @override
  String get name;
  @override
  String get password;
  @override
  int get port;
  @override
  String get method;
  @override
  String get accessUrl;
  @override
  bool get enable;
  @override
  bool get enableByAdmin;
  @override
  int get dataLimit;
  @override
  int get dataUsage;
  @override
  int get dataExpand;
  @override
  ServerInfo get serverId;
  @override
  UserInfo get userId;
  @override
  String get account;
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  int get status;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of KeyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyDtoImplCopyWith<_$KeyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServerInfo _$ServerInfoFromJson(Map<String, dynamic> json) {
  return _ServerInfo.fromJson(json);
}

/// @nodoc
mixin _$ServerInfo {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ServerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerInfoCopyWith<ServerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerInfoCopyWith<$Res> {
  factory $ServerInfoCopyWith(
    ServerInfo value,
    $Res Function(ServerInfo) then,
  ) = _$ServerInfoCopyWithImpl<$Res, ServerInfo>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String location, String name});
}

/// @nodoc
class _$ServerInfoCopyWithImpl<$Res, $Val extends ServerInfo>
    implements $ServerInfoCopyWith<$Res> {
  _$ServerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? location = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerInfoImplCopyWith<$Res>
    implements $ServerInfoCopyWith<$Res> {
  factory _$$ServerInfoImplCopyWith(
    _$ServerInfoImpl value,
    $Res Function(_$ServerInfoImpl) then,
  ) = __$$ServerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String location, String name});
}

/// @nodoc
class __$$ServerInfoImplCopyWithImpl<$Res>
    extends _$ServerInfoCopyWithImpl<$Res, _$ServerInfoImpl>
    implements _$$ServerInfoImplCopyWith<$Res> {
  __$$ServerInfoImplCopyWithImpl(
    _$ServerInfoImpl _value,
    $Res Function(_$ServerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? location = null, Object? name = null}) {
    return _then(
      _$ServerInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerInfoImpl implements _ServerInfo {
  const _$ServerInfoImpl({
    @JsonKey(name: '_id') required this.id,
    required this.location,
    required this.name,
  });

  factory _$ServerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerInfoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String location;
  @override
  final String name;

  @override
  String toString() {
    return 'ServerInfo(id: $id, location: $location, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, location, name);

  /// Create a copy of ServerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerInfoImplCopyWith<_$ServerInfoImpl> get copyWith =>
      __$$ServerInfoImplCopyWithImpl<_$ServerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerInfoImplToJson(this);
  }
}

abstract class _ServerInfo implements ServerInfo {
  const factory _ServerInfo({
    @JsonKey(name: '_id') required final String id,
    required final String location,
    required final String name,
  }) = _$ServerInfoImpl;

  factory _ServerInfo.fromJson(Map<String, dynamic> json) =
      _$ServerInfoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get location;
  @override
  String get name;

  /// Create a copy of ServerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerInfoImplCopyWith<_$ServerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get role => throw _privateConstructorUsedError;
  int? get money => throw _privateConstructorUsedError;

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String email,
    String username,
    int role,
    int? money,
  });
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? role = null,
    Object? money = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as int,
            money: freezed == money
                ? _value.money
                : money // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
    _$UserInfoImpl value,
    $Res Function(_$UserInfoImpl) then,
  ) = __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String email,
    String username,
    int role,
    int? money,
  });
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
    _$UserInfoImpl _value,
    $Res Function(_$UserInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? role = null,
    Object? money = freezed,
  }) {
    return _then(
      _$UserInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as int,
        money: freezed == money
            ? _value.money
            : money // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl({
    @JsonKey(name: '_id') required this.id,
    required this.email,
    required this.username,
    required this.role,
    this.money,
  });

  factory _$UserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String email;
  @override
  final String username;
  @override
  final int role;
  @override
  final int? money;

  @override
  String toString() {
    return 'UserInfo(id: $id, email: $email, username: $username, role: $role, money: $money)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.money, money) || other.money == money));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, username, role, money);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoImplToJson(this);
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo({
    @JsonKey(name: '_id') required final String id,
    required final String email,
    required final String username,
    required final int role,
    final int? money,
  }) = _$UserInfoImpl;

  factory _UserInfo.fromJson(Map<String, dynamic> json) =
      _$UserInfoImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get email;
  @override
  String get username;
  @override
  int get role;
  @override
  int? get money;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
