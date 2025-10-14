// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keys_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeysResponseDtoImpl _$$KeysResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$KeysResponseDtoImpl(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => KeyDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  keys: (json['keys'] as List<dynamic>?)
      ?.map((e) => KeyDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
  currentPage: (json['currentPage'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  totalItems: (json['totalItems'] as num?)?.toInt(),
  hasNextPage: json['hasNextPage'] as bool?,
  hasPrevPage: json['hasPrevPage'] as bool?,
);

Map<String, dynamic> _$$KeysResponseDtoImplToJson(
  _$KeysResponseDtoImpl instance,
) => <String, dynamic>{
  'list': instance.list,
  'keys': instance.keys,
  'total': instance.total,
  'currentPage': instance.currentPage,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
  'totalItems': instance.totalItems,
  'hasNextPage': instance.hasNextPage,
  'hasPrevPage': instance.hasPrevPage,
};
