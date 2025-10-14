import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import '../datasources/payment_methods_api.dart';
import '../models/payment_method_dto.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsApi _api;
  PaymentMethodsRepositoryImpl(this._api);

  @override
  Future<Result<List<PaymentMethod>>> getActivePaymentMethods() async {
    try {
      final res = await _api.getActivePaymentMethods();
      final responseData = res.data as List<dynamic>;
      final paymentMethods = responseData
          .map(
            (json) => PaymentMethodDto.fromJson(json as Map<String, dynamic>),
          )
          .map((dto) => dto.toEntity())
          .toList();
      return Ok(paymentMethods);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }
}
