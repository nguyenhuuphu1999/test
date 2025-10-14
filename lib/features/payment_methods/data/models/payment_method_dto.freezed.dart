// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethodDto _$PaymentMethodDtoFromJson(Map<String, dynamic> json) {
  return _PaymentMethodDto.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get config => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodDtoCopyWith<PaymentMethodDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodDtoCopyWith<$Res> {
  factory $PaymentMethodDtoCopyWith(
    PaymentMethodDto value,
    $Res Function(PaymentMethodDto) then,
  ) = _$PaymentMethodDtoCopyWithImpl<$Res, PaymentMethodDto>;
  @useResult
  $Res call({
    int id,
    String name,
    String code,
    String type,
    String logoUrl,
    Map<String, dynamic> config,
    bool isActive,
  });
}

/// @nodoc
class _$PaymentMethodDtoCopyWithImpl<$Res, $Val extends PaymentMethodDto>
    implements $PaymentMethodDtoCopyWith<$Res> {
  _$PaymentMethodDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? type = null,
    Object? logoUrl = null,
    Object? config = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: null == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            config: null == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentMethodDtoImplCopyWith<$Res>
    implements $PaymentMethodDtoCopyWith<$Res> {
  factory _$$PaymentMethodDtoImplCopyWith(
    _$PaymentMethodDtoImpl value,
    $Res Function(_$PaymentMethodDtoImpl) then,
  ) = __$$PaymentMethodDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String code,
    String type,
    String logoUrl,
    Map<String, dynamic> config,
    bool isActive,
  });
}

/// @nodoc
class __$$PaymentMethodDtoImplCopyWithImpl<$Res>
    extends _$PaymentMethodDtoCopyWithImpl<$Res, _$PaymentMethodDtoImpl>
    implements _$$PaymentMethodDtoImplCopyWith<$Res> {
  __$$PaymentMethodDtoImplCopyWithImpl(
    _$PaymentMethodDtoImpl _value,
    $Res Function(_$PaymentMethodDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? type = null,
    Object? logoUrl = null,
    Object? config = null,
    Object? isActive = null,
  }) {
    return _then(
      _$PaymentMethodDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: null == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        config: null == config
            ? _value._config
            : config // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodDtoImpl implements _PaymentMethodDto {
  const _$PaymentMethodDtoImpl({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.logoUrl,
    required final Map<String, dynamic> config,
    required this.isActive,
  }) : _config = config;

  factory _$PaymentMethodDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String type;
  @override
  final String logoUrl;
  final Map<String, dynamic> _config;
  @override
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  @override
  final bool isActive;

  @override
  String toString() {
    return 'PaymentMethodDto(id: $id, name: $name, code: $code, type: $type, logoUrl: $logoUrl, config: $config, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    code,
    type,
    logoUrl,
    const DeepCollectionEquality().hash(_config),
    isActive,
  );

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodDtoImplCopyWith<_$PaymentMethodDtoImpl> get copyWith =>
      __$$PaymentMethodDtoImplCopyWithImpl<_$PaymentMethodDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodDtoImplToJson(this);
  }
}

abstract class _PaymentMethodDto implements PaymentMethodDto {
  const factory _PaymentMethodDto({
    required final int id,
    required final String name,
    required final String code,
    required final String type,
    required final String logoUrl,
    required final Map<String, dynamic> config,
    required final bool isActive,
  }) = _$PaymentMethodDtoImpl;

  factory _PaymentMethodDto.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get code;
  @override
  String get type;
  @override
  String get logoUrl;
  @override
  Map<String, dynamic> get config;
  @override
  bool get isActive;

  /// Create a copy of PaymentMethodDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodDtoImplCopyWith<_$PaymentMethodDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
