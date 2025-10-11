import 'package:dio/dio.dart';
import '../../utils/platform_info.dart';

class DeviceInterceptor extends Interceptor {
  final PlatformInfo platformInfo;

  DeviceInterceptor(this.platformInfo);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add device information to headers
    final deviceHeaders = platformInfo.toHeaders();
    options.headers.addAll(deviceHeaders);

    handler.next(options);
  }
}
