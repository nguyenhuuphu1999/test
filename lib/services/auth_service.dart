import 'package:dio/dio.dart';
import '../core/di/simple_injector.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/data/datasources/auth_api.dart';
import '../core/error/result.dart';

class AuthService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await initSimpleDI();
      _isInitialized = true;
    }
  }

  // Login
  static Future<Result<User>> login(String username, String password) async {
    await initialize();
    final loginUseCase = sl<LoginUseCase>();
    return await loginUseCase(username: username, password: password);
  }

  // Register
  static Future<Result<User>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    await initialize();
    final registerUseCase = sl<RegisterUseCase>();
    return await registerUseCase(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  // Forgot Password
  static Future<void> forgotPassword(String email) async {
    await initialize();
    final authApi = sl<AuthApi>();
    await authApi.forgotPassword(email);
  }

  // Reset Password
  static Future<void> resetPassword(String token, String password) async {
    await initialize();
    final authApi = sl<AuthApi>();
    await authApi.resetPassword(token: token, password: password);
  }

  // Change Password
  static Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await initialize();
    final authApi = sl<AuthApi>();
    await authApi.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  // Get Current User
  static Future<Result<User>> getCurrentUser() async {
    await initialize();
    final authRepository = sl<AuthRepository>();
    return await authRepository.getCurrentUser();
  }

  // Logout
  static Future<void> logout() async {
    await initialize();
    final authRepository = sl<AuthRepository>();
    await authRepository.logout();
  }
}
