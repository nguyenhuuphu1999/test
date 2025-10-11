import '../../../../core/error/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String username, String password);
  Future<Result<User>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  });
  Future<Result<User>> getCurrentUser();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword({
    required String token,
    required String password,
  });
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Result<void>> logout();
}
