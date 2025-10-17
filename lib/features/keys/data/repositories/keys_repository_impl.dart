import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/key.dart';
import '../../domain/repositories/keys_repository.dart';
import '../datasources/keys_api.dart';
import '../models/key_dto.dart';
import '../models/keys_response_dto.dart';

class KeysRepositoryImpl implements KeysRepository {
  final KeysApi _keysApi;

  KeysRepositoryImpl(this._keysApi);

  @override
  Future<Result<List<Key>>> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      final response = await _keysApi.getKeys(
        page: page,
        limit: pageSize,
        search: search,
        status: status,
      );

      final responseData = response.data as Map<String, dynamic>;
      // Handle nested response structure: {data: {list: [...], keys: [...], total: 1, ...}}
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;
      final dto = KeysResponseDto.fromJson(data);
      // Use 'list' if available, otherwise fall back to 'keys'
      final keysList = dto.list ?? dto.keys ?? [];
      final keys = keysList.map((keyDto) => keyDto.toEntity()).toList();
      return Ok(keys);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }

  @override
  Future<Result<Key>> getKeyDetail(String keyId) async {
    try {
      final response = await _keysApi.getKeyDetail(keyId);
      final responseData = response.data as Map<String, dynamic>;
      // Handle nested response structure: {data: {...}}
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;
      final dto = KeyDto.fromJson(data);
      final key = dto.toEntity();
      return Ok(key);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }

  @override
  Future<Result<Key>> getKeyDetailV2(String keyId) async {
    try {
      final response = await _keysApi.getKeyDetailV2(keyId);
      final responseData = response.data as Map<String, dynamic>;
      final data =
          responseData['data'] as Map<String, dynamic>? ?? responseData;

      // Map new response shape to existing Key entity
      final server = data['server'] as Map<String, dynamic>?;
      final location = server?['location'] as Map<String, dynamic>?;

      final key = Key(
        id: data['keyId']?.toString() ?? '',
        keyId: data['keyId']?.toString() ?? '',
        name: data['keyName']?.toString() ?? '',
        password: '',
        port: 443,
        method: 'chacha20-ietf-poly1305',
        accessUrl: '',
        enable: true,
        enableByAdmin: true,
        dataLimit: (data['dataLimit'] as num?)?.toInt() ?? 0,
        dataUsage: (data['dataUsage'] as num?)?.toInt() ?? 0,
        dataExpand: (data['dataLimit'] as num?)?.toInt() ?? 0,
        serverLocation: location?['locationName']?.toString() ?? 'Unknown',
        serverName: server?['name']?.toString() ?? 'Unknown Server',
        account: '',
        startDate:
            DateTime.tryParse(server?['startTime']?.toString() ?? '') ??
            DateTime.now(),
        endDate:
            DateTime.tryParse(data['endDate']?.toString() ?? '') ??
            DateTime.now(),
        status: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ossId: null,
        fileName: null,
        prefix: null,
      );
      return Ok(key);
    } on DioException catch (e) {
      return Err(ResultMapper.mapDioError(e));
    } catch (e) {
      return Err(UnknownFailure(message: '$e'));
    }
  }
}
