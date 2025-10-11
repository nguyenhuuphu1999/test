import 'package:dio/dio.dart';
import '../../storage/token_store.dart';

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
      // Clear invalid tokens
      await TokenStore.clearTokens();

      // TODO: Implement refresh token flow if needed
      // For now, we just clear the tokens and let the user re-login
    }

    handler.next(err);
  }

  // Optional: Implement refresh token flow
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenStore.refreshToken;
      if (refreshToken == null) return false;

      // TODO: Call refresh token endpoint
      // final response = await dio.post('/auth/refresh', data: {'refresh_token': refreshToken});
      // await TokenStore.saveTokens(accessToken: response.data['access_token']);

      return true;
    } catch (e) {
      // Refresh failed, clear all tokens
      await TokenStore.clearTokens();
      return false;
    }
  }
}
