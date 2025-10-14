// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlanDto _$PlanDtoFromJson(Map<String, dynamic> json) {
  return _PlanDto.fromJson(json);
}

/// @nodoc
mixin _$PlanDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  List<String> get description => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;
  int get bandWidth => throw _privateConstructorUsedError;
  int get display => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  int get enable => throw _privateConstructorUsedError;
  int get numberPurchase => throw _privateConstructorUsedError;
  bool get isHotSales => throw _privateConstructorUsedError;

  /// Serializes this PlanDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanDtoCopyWith<PlanDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanDtoCopyWith<$Res> {
  factory $PlanDtoCopyWith(PlanDto value, $Res Function(PlanDto) then) =
      _$PlanDtoCopyWithImpl<$Res, PlanDto>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String type,
    List<String> description,
    int day,
    int bandWidth,
    int display,
    int status,
    int enable,
    int numberPurchase,
    bool isHotSales,
  });
}

/// @nodoc
class _$PlanDtoCopyWithImpl<$Res, $Val extends PlanDto>
    implements $PlanDtoCopyWith<$Res> {
  _$PlanDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? type = null,
    Object? description = null,
    Object? day = null,
    Object? bandWidth = null,
    Object? display = null,
    Object? status = null,
    Object? enable = null,
    Object? numberPurchase = null,
    Object? isHotSales = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            bandWidth: null == bandWidth
                ? _value.bandWidth
                : bandWidth // ignore: cast_nullable_to_non_nullable
                      as int,
            display: null == display
                ? _value.display
                : display // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            enable: null == enable
                ? _value.enable
                : enable // ignore: cast_nullable_to_non_nullable
                      as int,
            numberPurchase: null == numberPurchase
                ? _value.numberPurchase
                : numberPurchase // ignore: cast_nullable_to_non_nullable
                      as int,
            isHotSales: null == isHotSales
                ? _value.isHotSales
                : isHotSales // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlanDtoImplCopyWith<$Res> implements $PlanDtoCopyWith<$Res> {
  factory _$$PlanDtoImplCopyWith(
    _$PlanDtoImpl value,
    $Res Function(_$PlanDtoImpl) then,
  ) = __$$PlanDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String type,
    List<String> description,
    int day,
    int bandWidth,
    int display,
    int status,
    int enable,
    int numberPurchase,
    bool isHotSales,
  });
}

/// @nodoc
class __$$PlanDtoImplCopyWithImpl<$Res>
    extends _$PlanDtoCopyWithImpl<$Res, _$PlanDtoImpl>
    implements _$$PlanDtoImplCopyWith<$Res> {
  __$$PlanDtoImplCopyWithImpl(
    _$PlanDtoImpl _value,
    $Res Function(_$PlanDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? type = null,
    Object? description = null,
    Object? day = null,
    Object? bandWidth = null,
    Object? display = null,
    Object? status = null,
    Object? enable = null,
    Object? numberPurchase = null,
    Object? isHotSales = null,
  }) {
    return _then(
      _$PlanDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value._description
            : description // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        bandWidth: null == bandWidth
            ? _value.bandWidth
            : bandWidth // ignore: cast_nullable_to_non_nullable
                  as int,
        display: null == display
            ? _value.display
            : display // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        enable: null == enable
            ? _value.enable
            : enable // ignore: cast_nullable_to_non_nullable
                  as int,
        numberPurchase: null == numberPurchase
            ? _value.numberPurchase
            : numberPurchase // ignore: cast_nullable_to_non_nullable
                  as int,
        isHotSales: null == isHotSales
            ? _value.isHotSales
            : isHotSales // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanDtoImpl implements _PlanDto {
  const _$PlanDtoImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required final List<String> description,
    required this.day,
    required this.bandWidth,
    required this.display,
    required this.status,
    required this.enable,
    required this.numberPurchase,
    required this.isHotSales,
  }) : _description = description;

  factory _$PlanDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final String type;
  final List<String> _description;
  @override
  List<String> get description {
    if (_description is EqualUnmodifiableListView) return _description;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_description);
  }

  @override
  final int day;
  @override
  final int bandWidth;
  @override
  final int display;
  @override
  final int status;
  @override
  final int enable;
  @override
  final int numberPurchase;
  @override
  final bool isHotSales;

  @override
  String toString() {
    return 'PlanDto(id: $id, name: $name, price: $price, type: $type, description: $description, day: $day, bandWidth: $bandWidth, display: $display, status: $status, enable: $enable, numberPurchase: $numberPurchase, isHotSales: $isHotSales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._description,
              _description,
            ) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.bandWidth, bandWidth) ||
                other.bandWidth == bandWidth) &&
            (identical(other.display, display) || other.display == display) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.enable, enable) || other.enable == enable) &&
            (identical(other.numberPurchase, numberPurchase) ||
                other.numberPurchase == numberPurchase) &&
            (identical(other.isHotSales, isHotSales) ||
                other.isHotSales == isHotSales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    type,
    const DeepCollectionEquality().hash(_description),
    day,
    bandWidth,
    display,
    status,
    enable,
    numberPurchase,
    isHotSales,
  );

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanDtoImplCopyWith<_$PlanDtoImpl> get copyWith =>
      __$$PlanDtoImplCopyWithImpl<_$PlanDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanDtoImplToJson(this);
  }
}

abstract class _PlanDto implements PlanDto {
  const factory _PlanDto({
    required final String id,
    required final String name,
    required final double price,
    required final String type,
    required final List<String> description,
    required final int day,
    required final int bandWidth,
    required final int display,
    required final int status,
    required final int enable,
    required final int numberPurchase,
    required final bool isHotSales,
  }) = _$PlanDtoImpl;

  factory _PlanDto.fromJson(Map<String, dynamic> json) = _$PlanDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  String get type;
  @override
  List<String> get description;
  @override
  int get day;
  @override
  int get bandWidth;
  @override
  int get display;
  @override
  int get status;
  @override
  int get enable;
  @override
  int get numberPurchase;
  @override
  bool get isHotSales;

  /// Create a copy of PlanDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanDtoImplCopyWith<_$PlanDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlansResponseDto _$PlansResponseDtoFromJson(Map<String, dynamic> json) {
  return _PlansResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PlansResponseDto {
  List<PlanDto> get plans => throw _privateConstructorUsedError;

  /// Serializes this PlansResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlansResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlansResponseDtoCopyWith<PlansResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlansResponseDtoCopyWith<$Res> {
  factory $PlansResponseDtoCopyWith(
    PlansResponseDto value,
    $Res Function(PlansResponseDto) then,
  ) = _$PlansResponseDtoCopyWithImpl<$Res, PlansResponseDto>;
  @useResult
  $Res call({List<PlanDto> plans});
}

/// @nodoc
class _$PlansResponseDtoCopyWithImpl<$Res, $Val extends PlansResponseDto>
    implements $PlansResponseDtoCopyWith<$Res> {
  _$PlansResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlansResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? plans = null}) {
    return _then(
      _value.copyWith(
            plans: null == plans
                ? _value.plans
                : plans // ignore: cast_nullable_to_non_nullable
                      as List<PlanDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlansResponseDtoImplCopyWith<$Res>
    implements $PlansResponseDtoCopyWith<$Res> {
  factory _$$PlansResponseDtoImplCopyWith(
    _$PlansResponseDtoImpl value,
    $Res Function(_$PlansResponseDtoImpl) then,
  ) = __$$PlansResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PlanDto> plans});
}

/// @nodoc
class __$$PlansResponseDtoImplCopyWithImpl<$Res>
    extends _$PlansResponseDtoCopyWithImpl<$Res, _$PlansResponseDtoImpl>
    implements _$$PlansResponseDtoImplCopyWith<$Res> {
  __$$PlansResponseDtoImplCopyWithImpl(
    _$PlansResponseDtoImpl _value,
    $Res Function(_$PlansResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlansResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? plans = null}) {
    return _then(
      _$PlansResponseDtoImpl(
        plans: null == plans
            ? _value._plans
            : plans // ignore: cast_nullable_to_non_nullable
                  as List<PlanDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlansResponseDtoImpl implements _PlansResponseDto {
  const _$PlansResponseDtoImpl({required final List<PlanDto> plans})
    : _plans = plans;

  factory _$PlansResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlansResponseDtoImplFromJson(json);

  final List<PlanDto> _plans;
  @override
  List<PlanDto> get plans {
    if (_plans is EqualUnmodifiableListView) return _plans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plans);
  }

  @override
  String toString() {
    return 'PlansResponseDto(plans: $plans)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlansResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._plans, _plans));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_plans));

  /// Create a copy of PlansResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlansResponseDtoImplCopyWith<_$PlansResponseDtoImpl> get copyWith =>
      __$$PlansResponseDtoImplCopyWithImpl<_$PlansResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlansResponseDtoImplToJson(this);
  }
}

abstract class _PlansResponseDto implements PlansResponseDto {
  const factory _PlansResponseDto({required final List<PlanDto> plans}) =
      _$PlansResponseDtoImpl;

  factory _PlansResponseDto.fromJson(Map<String, dynamic> json) =
      _$PlansResponseDtoImpl.fromJson;

  @override
  List<PlanDto> get plans;

  /// Create a copy of PlansResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlansResponseDtoImplCopyWith<_$PlansResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
