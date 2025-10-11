import 'package:freezed_annotation/freezed_annotation.dart';
import 'key_dto.dart';

part 'keys_response_dto.freezed.dart';
part 'keys_response_dto.g.dart';

@freezed
class KeysResponseDto with _$KeysResponseDto {
  const factory KeysResponseDto({
    required int currentPage,
    required int totalPage,
    required int itemsPerPage,
    required int totalItems,
    required List<KeyDto> data,
  }) = _KeysResponseDto;

  factory KeysResponseDto.fromJson(Map<String, dynamic> json) =>
      _$KeysResponseDtoFromJson(json);
}
