// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanDtoImpl _$$PlanDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlanDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      type: json['type'] as String,
      description: (json['description'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      day: (json['day'] as num).toInt(),
      bandWidth: (json['bandWidth'] as num).toInt(),
      display: (json['display'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      enable: (json['enable'] as num).toInt(),
      numberPurchase: (json['numberPurchase'] as num).toInt(),
      isHotSales: json['isHotSales'] as bool,
    );

Map<String, dynamic> _$$PlanDtoImplToJson(_$PlanDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'type': instance.type,
      'description': instance.description,
      'day': instance.day,
      'bandWidth': instance.bandWidth,
      'display': instance.display,
      'status': instance.status,
      'enable': instance.enable,
      'numberPurchase': instance.numberPurchase,
      'isHotSales': instance.isHotSales,
    };

_$PlansResponseDtoImpl _$$PlansResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PlansResponseDtoImpl(
  plans: (json['plans'] as List<dynamic>)
      .map((e) => PlanDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PlansResponseDtoImplToJson(
  _$PlansResponseDtoImpl instance,
) => <String, dynamic>{'plans': instance.plans};
