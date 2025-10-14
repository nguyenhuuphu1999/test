import '../../../../core/error/result.dart';
import '../entities/payment_method.dart';

abstract class PaymentMethodsRepository {
  Future<Result<List<PaymentMethod>>> getActivePaymentMethods();
}
