import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../core/error/result.dart';
import '../features/plans/data/datasources/plans_api.dart';
import '../features/plans/data/repositories/plans_repository_impl.dart';
import '../features/plans/domain/entities/plan.dart';
import '../features/plans/domain/repositories/plans_repository.dart';

class PlansService {
  static bool _isInitialized = false;
  static late PlansRepository _repository;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      final dio = sl<Dio>();
      _repository = PlansRepositoryImpl(PlansApi(dio));
      _isInitialized = true;
    }
  }

  static Future<Result<PlansResponse>> getPlans({
    String? name,
    int? display,
    int? status,
    int? enable,
  }) async {
    await initialize();
    return _repository.getPlans(
      name: name,
      display: display,
      status: status,
      enable: enable,
    );
  }
}
