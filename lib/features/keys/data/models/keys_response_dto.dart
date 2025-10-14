import 'package:freezed_annotation/freezed_annotation.dart';
import 'key_dto.dart';

part 'keys_response_dto.freezed.dart';
part 'keys_response_dto.g.dart';

@freezed
class KeysResponseDto with _$KeysResponseDto {
  const factory KeysResponseDto({
    List<KeyDto>? list,
    List<KeyDto>? keys,
    int? total,
    int? currentPage,
    int? page,
    int? limit,
    int? totalPages,
    int? totalItems,
    bool? hasNextPage,
    bool? hasPrevPage,
  }) = _KeysResponseDto;

  factory KeysResponseDto.fromJson(Map<String, dynamic> json) =>
      _$KeysResponseDtoFromJson(json);
}
