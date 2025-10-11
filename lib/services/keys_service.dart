import '../core/di/simple_injector.dart';
import '../features/keys/domain/entities/key.dart';
import '../features/keys/domain/usecases/get_keys_usecase.dart';
import '../core/error/result.dart';

class KeysService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      _isInitialized = true;
    }
  }

  // Get keys from API
  static Future<Result<List<Key>>> getKeys({
    int status = 1,
    int page = 1,
    int pageSize = 10,
  }) async {
    await initialize();
    final getKeysUseCase = sl<GetKeysUseCase>();
    return await getKeysUseCase(status: status, page: page, pageSize: pageSize);
  }
}
