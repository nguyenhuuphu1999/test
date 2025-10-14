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
  List<KeyDto>? get list => throw _privateConstructorUsedError;
  List<KeyDto>? get keys => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;
  int? get currentPage => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  int? get totalItems => throw _privateConstructorUsedError;
  bool? get hasNextPage => throw _privateConstructorUsedError;
  bool? get hasPrevPage => throw _privateConstructorUsedError;

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
    Object? list = freezed,
    Object? keys = freezed,
    Object? total = freezed,
    Object? currentPage = freezed,
    Object? page = freezed,
    Object? limit = freezed,
    Object? totalPages = freezed,
    Object? totalItems = freezed,
    Object? hasNextPage = freezed,
    Object? hasPrevPage = freezed,
  }) {
    return _then(
      _value.copyWith(
            list: freezed == list
                ? _value.list
                : list // ignore: cast_nullable_to_non_nullable
                      as List<KeyDto>?,
            keys: freezed == keys
                ? _value.keys
                : keys // ignore: cast_nullable_to_non_nullable
                      as List<KeyDto>?,
            total: freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentPage: freezed == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int?,
            page: freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int?,
            limit: freezed == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalPages: freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalItems: freezed == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int?,
            hasNextPage: freezed == hasNextPage
                ? _value.hasNextPage
                : hasNextPage // ignore: cast_nullable_to_non_nullable
                      as bool?,
            hasPrevPage: freezed == hasPrevPage
                ? _value.hasPrevPage
                : hasPrevPage // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
    Object? list = freezed,
    Object? keys = freezed,
    Object? total = freezed,
    Object? currentPage = freezed,
    Object? page = freezed,
    Object? limit = freezed,
    Object? totalPages = freezed,
    Object? totalItems = freezed,
    Object? hasNextPage = freezed,
    Object? hasPrevPage = freezed,
  }) {
    return _then(
      _$KeysResponseDtoImpl(
        list: freezed == list
            ? _value._list
            : list // ignore: cast_nullable_to_non_nullable
                  as List<KeyDto>?,
        keys: freezed == keys
            ? _value._keys
            : keys // ignore: cast_nullable_to_non_nullable
                  as List<KeyDto>?,
        total: freezed == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentPage: freezed == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int?,
        page: freezed == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalPages: freezed == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalItems: freezed == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int?,
        hasNextPage: freezed == hasNextPage
            ? _value.hasNextPage
            : hasNextPage // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hasPrevPage: freezed == hasPrevPage
            ? _value.hasPrevPage
            : hasPrevPage // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeysResponseDtoImpl implements _KeysResponseDto {
  const _$KeysResponseDtoImpl({
    final List<KeyDto>? list,
    final List<KeyDto>? keys,
    this.total,
    this.currentPage,
    this.page,
    this.limit,
    this.totalPages,
    this.totalItems,
    this.hasNextPage,
    this.hasPrevPage,
  }) : _list = list,
       _keys = keys;

  factory _$KeysResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeysResponseDtoImplFromJson(json);

  final List<KeyDto>? _list;
  @override
  List<KeyDto>? get list {
    final value = _list;
    if (value == null) return null;
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<KeyDto>? _keys;
  @override
  List<KeyDto>? get keys {
    final value = _keys;
    if (value == null) return null;
    if (_keys is EqualUnmodifiableListView) return _keys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? total;
  @override
  final int? currentPage;
  @override
  final int? page;
  @override
  final int? limit;
  @override
  final int? totalPages;
  @override
  final int? totalItems;
  @override
  final bool? hasNextPage;
  @override
  final bool? hasPrevPage;

  @override
  String toString() {
    return 'KeysResponseDto(list: $list, keys: $keys, total: $total, currentPage: $currentPage, page: $page, limit: $limit, totalPages: $totalPages, totalItems: $totalItems, hasNextPage: $hasNextPage, hasPrevPage: $hasPrevPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeysResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            const DeepCollectionEquality().equals(other._keys, _keys) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPrevPage, hasPrevPage) ||
                other.hasPrevPage == hasPrevPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_list),
    const DeepCollectionEquality().hash(_keys),
    total,
    currentPage,
    page,
    limit,
    totalPages,
    totalItems,
    hasNextPage,
    hasPrevPage,
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
    final List<KeyDto>? list,
    final List<KeyDto>? keys,
    final int? total,
    final int? currentPage,
    final int? page,
    final int? limit,
    final int? totalPages,
    final int? totalItems,
    final bool? hasNextPage,
    final bool? hasPrevPage,
  }) = _$KeysResponseDtoImpl;

  factory _KeysResponseDto.fromJson(Map<String, dynamic> json) =
      _$KeysResponseDtoImpl.fromJson;

  @override
  List<KeyDto>? get list;
  @override
  List<KeyDto>? get keys;
  @override
  int? get total;
  @override
  int? get currentPage;
  @override
  int? get page;
  @override
  int? get limit;
  @override
  int? get totalPages;
  @override
  int? get totalItems;
  @override
  bool? get hasNextPage;
  @override
  bool? get hasPrevPage;

  /// Create a copy of KeysResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeysResponseDtoImplCopyWith<_$KeysResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
