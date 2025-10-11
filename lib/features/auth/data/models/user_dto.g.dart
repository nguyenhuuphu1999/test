// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  role: (json['role'] as num?)?.toInt(),
  money: (json['money'] as num?)?.toInt(),
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  expiresIn: json['expiresIn'] as String?,
  v: (json['__v'] as num?)?.toInt(),
  cash: (json['cash'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  level: (json['level'] as num?)?.toInt(),
  purpose: (json['purpose'] as num?)?.toInt(),
  transaction: (json['transaction'] as num?)?.toInt(),
  mongoId: json['_id'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'role': instance.role,
  'money': instance.money,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
  '__v': instance.v,
  'cash': instance.cash,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'level': instance.level,
  'purpose': instance.purpose,
  'transaction': instance.transaction,
  '_id': instance.mongoId,
};
