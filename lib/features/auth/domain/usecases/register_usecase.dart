import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<Result<User>> call({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Validation
    if (username.isEmpty) {
      return const Result.err(
        Failure.validation(message: 'Username is required'),
      );
    }

    if (email.isEmpty) {
      return const Result.err(Failure.validation(message: 'Email is required'));
    }

    if (password.isEmpty) {
      return const Result.err(
        Failure.validation(message: 'Password is required'),
      );
    }

    if (fullName.isEmpty) {
      return const Result.err(
        Failure.validation(message: 'Full name is required'),
      );
    }

    // Email validation
    if (!_isValidEmail(email)) {
      return const Result.err(
        Failure.validation(message: 'Invalid email format'),
      );
    }

    // Password validation
    if (password.length < 6) {
      return const Result.err(
        Failure.validation(message: 'Password must be at least 6 characters'),
      );
    }

    return await _authRepository.register(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
