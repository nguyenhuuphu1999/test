import 'package:dio/dio.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../../../../core/storage/token_store.dart';
import '../datasources/auth_api.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl({required AuthApi authApi}) : _authApi = authApi;

  @override
  Future<Result<User>> login(String username, String password) async {
    try {
      final request = LoginRequest(account: username, password: password);
      final userDto = await _authApi.login(request);

      // Save tokens if available
      if (userDto.accessToken != null) {
        await TokenStore.saveTokens(
          accessToken: userDto.accessToken!,
          refreshToken: userDto.refreshToken,
        );
      }

      return Result.ok(userDto.toEntity());
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<User>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        confirmPassword: password,
      );
      final userDto = await _authApi.register(request);

      // Save tokens if available
      if (userDto.accessToken != null) {
        await TokenStore.saveTokens(
          accessToken: userDto.accessToken!,
          refreshToken: userDto.refreshToken,
        );
      }

      return Result.ok(userDto.toEntity());
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final userDto = await _authApi.getCurrentUser();
      return Result.ok(userDto.toEntity());
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _authApi.forgotPassword(email);
      return const Result.ok(null);
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _authApi.resetPassword(token: token, password: password);
      return const Result.ok(null);
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authApi.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Result.ok(null);
    } on DioException catch (e) {
      return Result.err(ApiErrorMapper.mapError(e));
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Clear tokens from storage
      await TokenStore.clearTokens();
      return const Result.ok(null);
    } catch (e) {
      return Result.err(Failure.unknown(message: e.toString(), error: e));
    }
  }
}
