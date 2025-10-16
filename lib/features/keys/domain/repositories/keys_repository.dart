import '../../../../core/error/result.dart';
import '../entities/key.dart';

abstract class KeysRepository {
  Future<Result<List<Key>>> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
    String? search,
  });

  Future<Result<Key>> getKeyDetail(String keyId);
  Future<Result<Key>> getKeyDetailV2(String keyId);
}
