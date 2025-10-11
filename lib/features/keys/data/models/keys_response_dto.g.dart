// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keys_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeysResponseDtoImpl _$$KeysResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$KeysResponseDtoImpl(
  currentPage: (json['currentPage'] as num).toInt(),
  totalPage: (json['totalPage'] as num).toInt(),
  itemsPerPage: (json['itemsPerPage'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => KeyDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$KeysResponseDtoImplToJson(
  _$KeysResponseDtoImpl instance,
) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'totalPage': instance.totalPage,
  'itemsPerPage': instance.itemsPerPage,
  'totalItems': instance.totalItems,
  'data': instance.data,
};
