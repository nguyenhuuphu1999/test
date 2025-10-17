import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'failures.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.ok(T data) = Ok<T>;
  const factory Result.err(Failure failure) = Err<T>;
}

extension ResultX<T> on Result<T> {
  bool get isOk => maybeWhen(ok: (_) => true, orElse: () => false);
  bool get isErr => maybeWhen(err: (_) => true, orElse: () => false);

  T? get data => maybeWhen(ok: (data) => data, orElse: () => null);
  Failure? get failure =>
      maybeWhen(err: (failure) => failure, orElse: () => null);

  Result<R> map<R>(R Function(T) mapper) {
    return when(
      ok: (data) => Result.ok(mapper(data)),
      err: (failure) => Result.err(failure),
    );
  }

  Result<R> flatMap<R>(Result<R> Function(T) mapper) {
    return when(
      ok: (data) => mapper(data),
      err: (failure) => Result.err(failure),
    );
  }

  T getOrElse(T Function(Failure) fallback) {
    return when(ok: (data) => data, err: (failure) => fallback(failure));
  }

  T getOrThrow() {
    return when(
      ok: (data) => data,
      err: (failure) => throw Exception(failure.displayMessage),
    );
  }
}

class ResultMapper {
  static Failure mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure.timeout(message: 'Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 401) {
          return const Failure.auth(message: 'Unauthorized');
        }

        if (statusCode == 422) {
          // Validation error
          String message = 'Validation failed';
          Map<String, List<String>>? errors;

          if (data is Map<String, dynamic>) {
            if (data['message'] != null) {
              final raw = data['message'];
              if (raw is List) {
                message = raw.join(', ');
              } else {
                message = raw.toString();
              }
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

        String serverMsg = 'Server error';
        final rawMsg = data?['message'];
        if (rawMsg != null) {
          serverMsg = rawMsg is List ? rawMsg.join(', ') : rawMsg.toString();
        }
        return Failure.server(message: serverMsg, statusCode: statusCode);

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

  static Failure mapGenericError(dynamic error) {
    if (error is DioException) {
      return mapDioError(error);
    }

    return Failure.unknown(message: error.toString(), error: error);
  }
}
