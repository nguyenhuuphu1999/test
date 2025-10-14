import '../../../../core/error/result.dart';
import '../entities/plan.dart';

abstract class PlansRepository {
  Future<Result<PlansResponse>> getPlans({
    String? name,
    int? display,
    int? status,
    int? enable,
  });
}
