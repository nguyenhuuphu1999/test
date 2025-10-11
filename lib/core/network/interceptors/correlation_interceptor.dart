import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class CorrelationInterceptor extends Interceptor {
  final _uuid = const Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Generate new correlation ID for each request
    options.headers['x-correlation-id'] = _uuid.v4();
    handler.next(options);
  }
}
