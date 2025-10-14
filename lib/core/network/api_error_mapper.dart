import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../error/failures.dart';

class ApiErrorMapper {
  static Failure mapError(dynamic error) {
    if (error is DioException) {
      return _mapDioError(error);
    }

    return Failure.unknown(message: error.toString(), error: error);
  }

  static Failure _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.timeout(message: 'Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        // Extract error message from response
        String message = _extractErrorMessage(data);

        if (statusCode == 400) {
          return Failure.client(
            message: message.isNotEmpty
                ? message
                : 'Bad Request - Invalid input',
            statusCode: statusCode,
          );
        }

        if (statusCode == 401) {
          debugPrint('🔴 API Error Mapper: 401 Unauthorized detected');
          debugPrint('📄 Response data: $data');
          // Auto-logout will be handled by AuthInterceptor
          return Failure.auth(
            message: message.isNotEmpty
                ? message
                : 'Unauthorized - Please login again',
          );
        }

        if (statusCode == 403) {
          return Failure.client(
            message: message.isNotEmpty ? message : 'Forbidden - Access denied',
            statusCode: statusCode,
          );
        }

        if (statusCode == 404) {
          return Failure.client(
            message: message.isNotEmpty
                ? message
                : 'Not Found - Resource not available',
            statusCode: statusCode,
          );
        }

        if (statusCode == 408) {
          return Failure.timeout(
            message: message.isNotEmpty
                ? message
                : 'Request timeout - Please try again',
          );
        }

        if (statusCode == 409) {
          return Failure.client(
            message: message.isNotEmpty
                ? message
                : 'Conflict - Resource already exists',
            statusCode: statusCode,
          );
        }

        if (statusCode == 422) {
          Map<String, List<String>>? errors;
          if (data is Map<String, dynamic> && data['errors'] != null) {
            errors = Map<String, List<String>>.from(
              data['errors'].map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
            );
          }
          return Failure.validation(
            message: message.isNotEmpty ? message : 'Validation failed',
            errors: errors,
          );
        }

        if (statusCode == 429) {
          return Failure.client(
            message: message.isNotEmpty
                ? message
                : 'Too many requests - Please wait',
            statusCode: statusCode,
          );
        }

        if (statusCode != null && statusCode >= 500) {
          return Failure.server(
            message: message.isNotEmpty
                ? message
                : 'Server error - Please try again later',
            statusCode: statusCode,
          );
        }

        // Handle other 4xx errors
        if (statusCode != null && statusCode >= 400) {
          return Failure.client(
            message: message.isNotEmpty ? message : 'Request failed',
            statusCode: statusCode,
          );
        }

        return Failure.server(
          message: message.isNotEmpty ? message : 'Server error',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const Failure.network(message: 'Request cancelled');

      case DioExceptionType.connectionError:
        return const Failure.network(message: 'No internet connection');

      case DioExceptionType.badCertificate:
        return const Failure.network(message: 'Certificate error');

      case DioExceptionType.unknown:
      default:
        return Failure.unknown(
          message: error.message ?? 'Unknown error',
          error: error,
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data == null) return '';

    if (data is Map<String, dynamic>) {
      // Try common error message fields
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['detail']?.toString() ??
          data['msg']?.toString() ??
          '';
    }

    if (data is String) {
      return data;
    }

    return '';
  }
}
