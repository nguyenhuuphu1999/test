import 'package:dio/dio.dart';

class PlansApi {
  final Dio _dio;
  PlansApi(Dio dio) : _dio = dio;

  Future<Response<dynamic>> getPlans({
    String? name,
    int? display,
    int? status,
    int? enable,
  }) async {
    return _dio.get(
      '/mobile/plans',
      queryParameters: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (display != null) 'display': display,
        if (status != null) 'status': status,
        if (enable != null) 'enable': enable,
      },
      options: Options(headers: {'accept': 'application/json'}),
    );
  }
}
