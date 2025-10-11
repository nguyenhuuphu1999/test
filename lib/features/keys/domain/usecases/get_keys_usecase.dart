import '../../../../core/error/result.dart';
import '../entities/key.dart';
import '../repositories/keys_repository.dart';

class GetKeysUseCase {
  final KeysRepository _keysRepository;

  GetKeysUseCase(this._keysRepository);

  Future<Result<List<Key>>> call({
    int status = 1,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _keysRepository.getKeys(
      status: status,
      page: page,
      pageSize: pageSize,
    );
  }
}
