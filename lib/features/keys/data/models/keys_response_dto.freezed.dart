// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keys_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KeysResponseDto _$KeysResponseDtoFromJson(Map<String, dynamic> json) {
  return _KeysResponseDto.fromJson(json);
}

/// @nodoc
mixin _$KeysResponseDto {
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPage => throw _privateConstructorUsedError;
  int get itemsPerPage => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  List<KeyDto> get data => throw _privateConstructorUsedError;

  /// Serializes this KeysResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeysResponseDtoCopyWith<KeysResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeysResponseDtoCopyWith<$Res> {
  factory $KeysResponseDtoCopyWith(
    KeysResponseDto value,
    $Res Function(KeysResponseDto) then,
  ) = _$KeysResponseDtoCopyWithImpl<$Res, KeysResponseDto>;
  @useResult
  $Res call({
    int currentPage,
    int totalPage,
    int itemsPerPage,
    int totalItems,
    List<KeyDto> data,
  });
}

/// @nodoc
class _$KeysResponseDtoCopyWithImpl<$Res, $Val extends KeysResponseDto>
    implements $KeysResponseDtoCopyWith<$Res> {
  _$KeysResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPage = null,
    Object? itemsPerPage = null,
    Object? totalItems = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPage: null == totalPage
                ? _value.totalPage
                : totalPage // ignore: cast_nullable_to_non_nullable
                      as int,
            itemsPerPage: null == itemsPerPage
                ? _value.itemsPerPage
                : itemsPerPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<KeyDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeysResponseDtoImplCopyWith<$Res>
    implements $KeysResponseDtoCopyWith<$Res> {
  factory _$$KeysResponseDtoImplCopyWith(
    _$KeysResponseDtoImpl value,
    $Res Function(_$KeysResponseDtoImpl) then,
  ) = __$$KeysResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentPage,
    int totalPage,
    int itemsPerPage,
    int totalItems,
    List<KeyDto> data,
  });
}

/// @nodoc
class __$$KeysResponseDtoImplCopyWithImpl<$Res>
    extends _$KeysResponseDtoCopyWithImpl<$Res, _$KeysResponseDtoImpl>
    implements _$$KeysResponseDtoImplCopyWith<$Res> {
  __$$KeysResponseDtoImplCopyWithImpl(
    _$KeysResponseDtoImpl _value,
    $Res Function(_$KeysResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPage = null,
    Object? itemsPerPage = null,
    Object? totalItems = null,
    Object? data = null,
  }) {
    return _then(
      _$KeysResponseDtoImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPage: null == totalPage
            ? _value.totalPage
            : totalPage // ignore: cast_nullable_to_non_nullable
                  as int,
        itemsPerPage: null == itemsPerPage
            ? _value.itemsPerPage
            : itemsPerPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<KeyDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeysResponseDtoImpl implements _KeysResponseDto {
  const _$KeysResponseDtoImpl({
    required this.currentPage,
    required this.totalPage,
    required this.itemsPerPage,
    required this.totalItems,
    required final List<KeyDto> data,
  }) : _data = data;

  factory _$KeysResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeysResponseDtoImplFromJson(json);

  @override
  final int currentPage;
  @override
  final int totalPage;
  @override
  final int itemsPerPage;
  @override
  final int totalItems;
  final List<KeyDto> _data;
  @override
  List<KeyDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'KeysResponseDto(currentPage: $currentPage, totalPage: $totalPage, itemsPerPage: $itemsPerPage, totalItems: $totalItems, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeysResponseDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPage, totalPage) ||
                other.totalPage == totalPage) &&
            (identical(other.itemsPerPage, itemsPerPage) ||
                other.itemsPerPage == itemsPerPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    totalPage,
    itemsPerPage,
    totalItems,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeysResponseDtoImplCopyWith<_$KeysResponseDtoImpl> get copyWith =>
      __$$KeysResponseDtoImplCopyWithImpl<_$KeysResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KeysResponseDtoImplToJson(this);
  }
}

abstract class _KeysResponseDto implements KeysResponseDto {
  const factory _KeysResponseDto({
    required final int currentPage,
    required final int totalPage,
    required final int itemsPerPage,
    required final int totalItems,
    required final List<KeyDto> data,
  }) = _$KeysResponseDtoImpl;

  factory _KeysResponseDto.fromJson(Map<String, dynamic> json) =
      _$KeysResponseDtoImpl.fromJson;

  @override
  int get currentPage;
  @override
  int get totalPage;
  @override
  int get itemsPerPage;
  @override
  int get totalItems;
  @override
  List<KeyDto> get data;

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeysResponseDtoImplCopyWith<_$KeysResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
