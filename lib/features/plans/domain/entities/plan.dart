import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan.freezed.dart';

@freezed
class Plan with _$Plan {
  const factory Plan({
    required String id,
    required String name,
    required double price,
    required String type,
    required List<String> description,
    required int day,
    required int bandWidth,
    required int display,
    required int status,
    required int enable,
    required int numberPurchase,
    required bool isHotSales,
  }) = _Plan;
}

@freezed
class PlansResponse with _$PlansResponse {
  const factory PlansResponse({required List<Plan> plans}) = _PlansResponse;
}
