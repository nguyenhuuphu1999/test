import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Result<User>> call({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty) {
      return const Result.err(
        Failure.validation(message: 'Account is required'),
      );
    }

    if (password.isEmpty) {
      return const Result.err(
        Failure.validation(message: 'Password is required'),
      );
    }

    return await _authRepository.login(username, password);
  }
}
