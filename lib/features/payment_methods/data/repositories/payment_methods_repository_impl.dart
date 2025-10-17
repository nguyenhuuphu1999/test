import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/response_handler.dart';
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
      
      return ResponseHandler.handleListResponse<PaymentMethod>(
        res,
        (json) => PaymentMethodDto.fromJson(json).toEntity(),
        handleWrappedResponse: true,
      );
    } on DioException catch (e) {
      return ResponseHandler.handleDioException<List<PaymentMethod>>(e);
    } catch (e) {
      return Err(UnknownFailure(message: 'Failed to load payment methods: $e'));
    }
  }
}
