// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodDtoImpl _$$PaymentMethodDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentMethodDtoImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  code: json['code'] as String,
  type: json['type'] as String,
  logoUrl: json['logoUrl'] as String,
  config: json['config'] as Map<String, dynamic>,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$$PaymentMethodDtoImplToJson(
  _$PaymentMethodDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'type': instance.type,
  'logoUrl': instance.logoUrl,
  'config': instance.config,
  'isActive': instance.isActive,
};
