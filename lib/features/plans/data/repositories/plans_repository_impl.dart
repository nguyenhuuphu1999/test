import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/plan.dart';
import '../../domain/repositories/plans_repository.dart';
import '../datasources/plans_api.dart';
import '../models/plan_dto.dart';

class PlansRepositoryImpl implements PlansRepository {
  final PlansApi _api;
  PlansRepositoryImpl(this._api);

  @override
  Future<Result<PlansResponse>> getPlans({
    String? name,
    int? display,
    int? status,
    int? enable,
  }) async {
    try {
      final res = await _api.getPlans(
        name: name,
        display: display,
        status: status,
        enable: enable,
      );

      final responseData = res.data as Map<String, dynamic>;
      // Handle nested response structure: {data: {plans: [...]}}
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;
      final dto = PlansResponseDto.fromJson(data);
      final response = dto.toEntity();
      return Ok(response);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }
}
