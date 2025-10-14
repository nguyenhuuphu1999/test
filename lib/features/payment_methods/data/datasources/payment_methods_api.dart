import 'package:dio/dio.dart';

class PaymentMethodsApi {
  final Dio _dio;
  PaymentMethodsApi(Dio dio) : _dio = dio;

  Future<Response<dynamic>> getActivePaymentMethods() async {
    return _dio.get(
      '/mobile/payment-methods/active',
      options: Options(headers: {'accept': 'application/json'}),
    );
  }
}
