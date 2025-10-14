import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment_method.dart';

part 'payment_method_dto.freezed.dart';
part 'payment_method_dto.g.dart';

@freezed
class PaymentMethodDto with _$PaymentMethodDto {
  const factory PaymentMethodDto({
    required int id,
    required String name,
    required String code,
    required String type,
    required String logoUrl,
    required Map<String, dynamic> config,
    required bool isActive,
  }) = _PaymentMethodDto;

  factory PaymentMethodDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodDtoFromJson(json);
}

extension PaymentMethodDtoX on PaymentMethodDto {
  PaymentMethod toEntity() {
    return PaymentMethod(
      id: id,
      name: name,
      code: code,
      type: type,
      logoUrl: logoUrl,
      config: config,
      isActive: isActive,
    );
  }
}
