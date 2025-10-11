import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/key.dart';
import '../../domain/repositories/keys_repository.dart';
import '../datasources/keys_api.dart';
import '../models/key_dto.dart';

class KeysRepositoryImpl implements KeysRepository {
  final KeysApi _keysApi;

  KeysRepositoryImpl(this._keysApi);

  @override
  Future<Result<List<Key>>> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _keysApi.getKeys(
        status: status,
        page: page,
        pageSize: pageSize,
      );

      final keys = response.data.map((keyDto) => keyDto.toEntity()).toList();
      return Ok(keys);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }
}
