import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required int id,
    required String name,
    required String code,
    required String type,
    required String logoUrl,
    required Map<String, dynamic> config,
    required bool isActive,
  }) = _PaymentMethod;
}
