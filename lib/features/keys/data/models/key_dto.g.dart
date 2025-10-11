// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeyDtoImpl _$$KeyDtoImplFromJson(Map<String, dynamic> json) => _$KeyDtoImpl(
  id: json['_id'] as String,
  keyId: json['keyId'] as String,
  name: json['name'] as String,
  password: json['password'] as String,
  port: (json['port'] as num).toInt(),
  method: json['method'] as String,
  accessUrl: json['accessUrl'] as String,
  enable: json['enable'] as bool,
  enableByAdmin: json['enableByAdmin'] as bool,
  dataLimit: (json['dataLimit'] as num).toInt(),
  dataUsage: (json['dataUsage'] as num).toInt(),
  dataExpand: (json['dataExpand'] as num).toInt(),
  serverId: ServerInfo.fromJson(json['serverId'] as Map<String, dynamic>),
  userId: UserInfo.fromJson(json['userId'] as Map<String, dynamic>),
  account: json['account'] as String,
  startDate: json['startDate'] as String,
  endDate: json['endDate'] as String,
  status: (json['status'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$$KeyDtoImplToJson(_$KeyDtoImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'keyId': instance.keyId,
      'name': instance.name,
      'password': instance.password,
      'port': instance.port,
      'method': instance.method,
      'accessUrl': instance.accessUrl,
      'enable': instance.enable,
      'enableByAdmin': instance.enableByAdmin,
      'dataLimit': instance.dataLimit,
      'dataUsage': instance.dataUsage,
      'dataExpand': instance.dataExpand,
      'serverId': instance.serverId,
      'userId': instance.userId,
      'account': instance.account,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$ServerInfoImpl _$$ServerInfoImplFromJson(Map<String, dynamic> json) =>
    _$ServerInfoImpl(
      id: json['_id'] as String,
      location: json['location'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ServerInfoImplToJson(_$ServerInfoImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'location': instance.location,
      'name': instance.name,
    };

_$UserInfoImpl _$$UserInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoImpl(
      id: json['_id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: (json['role'] as num).toInt(),
      money: (json['money'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserInfoImplToJson(_$UserInfoImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'role': instance.role,
      'money': instance.money,
    };
