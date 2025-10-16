import 'package:dio/dio.dart';

class LocationsApi {
  final Dio _dio;
  LocationsApi(Dio dio) : _dio = dio;

  Future<Response<dynamic>> getLocationsByKey({required String keyId}) async {
    return _dio.get(
      '/mobile/get-locations/$keyId',
      options: Options(headers: {'accept': 'application/json'}),
    );
  }
}
