import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../core/error/result.dart';
import '../features/payment_methods/data/datasources/payment_methods_api.dart';
import '../features/payment_methods/data/repositories/payment_methods_repository_impl.dart';
import '../features/payment_methods/domain/entities/payment_method.dart';
import '../features/payment_methods/domain/repositories/payment_methods_repository.dart';

class PaymentMethodsService {
  static bool _isInitialized = false;
  static late PaymentMethodsRepository _repository;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      final dio = sl<Dio>();
      _repository = PaymentMethodsRepositoryImpl(PaymentMethodsApi(dio));
      _isInitialized = true;
    }
  }

  static Future<Result<List<PaymentMethod>>> getActivePaymentMethods() async {
    await initialize();
    return _repository.getActivePaymentMethods();
  }
}
