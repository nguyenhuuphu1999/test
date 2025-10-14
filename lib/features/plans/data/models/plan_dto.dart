import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/plan.dart';

part 'plan_dto.freezed.dart';
part 'plan_dto.g.dart';

@freezed
class PlanDto with _$PlanDto {
  const factory PlanDto({
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
  }) = _PlanDto;

  factory PlanDto.fromJson(Map<String, dynamic> json) =>
      _$PlanDtoFromJson(json);
}

extension PlanDtoX on PlanDto {
  Plan toEntity() {
    return Plan(
      id: id,
      name: name,
      price: price,
      type: type,
      description: description,
      day: day,
      bandWidth: bandWidth,
      display: display,
      status: status,
      enable: enable,
      numberPurchase: numberPurchase,
      isHotSales: isHotSales,
    );
  }
}

@freezed
class PlansResponseDto with _$PlansResponseDto {
  const factory PlansResponseDto({required List<PlanDto> plans}) =
      _PlansResponseDto;

  factory PlansResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PlansResponseDtoFromJson(json);
}

extension PlansResponseDtoX on PlansResponseDto {
  PlansResponse toEntity() {
    return PlansResponse(
      plans: plans.map((planDto) => planDto.toEntity()).toList(),
    );
  }
}
