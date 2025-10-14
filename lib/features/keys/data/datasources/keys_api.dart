import 'package:dio/dio.dart';

class KeysApi {
  final Dio _dio;

  KeysApi(this._dio);

  Future<Response<dynamic>> getKeys({
    int page = 1,
    int limit = 10,
    String? search,
    int status = 1,
  }) async {
    return _dio.get(
      '/mobile/keys',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        'status': status,
      },
      options: Options(headers: {'accept': 'application/json'}),
    );
  }

  Future<Response<dynamic>> getKeyDetail(String keyId) async {
    return _dio.get(
      '/mobile/keys/$keyId',
      options: Options(headers: {'accept': 'application/json'}),
    );
  }
}
