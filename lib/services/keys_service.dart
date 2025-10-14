import '../core/di/simple_injector.dart';
import '../features/keys/domain/entities/key.dart';
import '../features/keys/domain/repositories/keys_repository.dart';
import '../core/error/result.dart';

class KeysService {
  static bool _isInitialized = false;
  static late KeysRepository _repository;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      _repository = sl<KeysRepository>();
      _isInitialized = true;
    }
  }

  // Get keys from API
  static Future<Result<List<Key>>> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    await initialize();
    return _repository.getKeys(
      status: status,
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }

  // Get key detail from API
  static Future<Result<Key>> getKeyDetail(String keyId) async {
    await initialize();
    return _repository.getKeyDetail(keyId);
  }
}
