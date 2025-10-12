import 'package:dio/dio.dart';
import '../../storage/token_store.dart';
import '../../../services/auto_logout_service.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add authorization header if token exists
    final token = await TokenStore.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 errors - token expired or invalid
    if (err.response?.statusCode == 401) {
      debugPrint('🔴 401 Unauthorized - Auto logout triggered');

      // Perform complete logout with navigation
      await AutoLogoutService.performAutoLogout(
        reason: 'Unauthorized (401)',
        showMessage: true,
      );
    }

    handler.next(err);
  }
}
