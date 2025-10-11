import 'package:dio/dio.dart';
import '../models/keys_response_dto.dart';

class KeysApi {
  final Dio _dio;

  KeysApi(this._dio);

  Future<KeysResponseDto> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.get(
      '/keys',
      queryParameters: {'status': status, 'page': page, 'pageSize': pageSize},
    );

    final responseData = response.data as Map<String, dynamic>;
    return KeysResponseDto.fromJson(responseData);
  }
}
