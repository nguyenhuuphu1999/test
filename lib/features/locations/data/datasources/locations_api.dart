import 'package:dio/dio.dart';

class LocationsApi {
  final Dio _dio;
  LocationsApi(Dio dio) : _dio = dio;

  Future<Response<dynamic>> getLocations({
    required String deviceId,
    String? search,
  }) async {
    return _dio.get(
      '/mobile/locations',
      queryParameters: {
        'deviceId': deviceId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
      options: Options(headers: {'accept': 'application/json'}),
    );
  }
}
