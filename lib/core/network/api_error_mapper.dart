import 'package:dio/dio.dart';
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

        if (statusCode == 401) {
          return const Failure.auth(message: 'Unauthorized');
        }

        if (statusCode == 422) {
          String message = 'Validation failed';
          Map<String, List<String>>? errors;

          if (data is Map<String, dynamic>) {
            if (data['message'] != null) {
              message = data['message'].toString();
            }
            if (data['errors'] != null) {
              errors = Map<String, List<String>>.from(
                data['errors'].map(
                  (key, value) => MapEntry(key, List<String>.from(value)),
                ),
              );
            }
          }

          return Failure.validation(message: message, errors: errors);
        }

        if (statusCode != null && statusCode >= 500) {
          return Failure.server(
            message: data?['message'] ?? 'Server error',
            statusCode: statusCode,
          );
        }

        return Failure.server(
          message: data?['message'] ?? 'Server error',
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
}
