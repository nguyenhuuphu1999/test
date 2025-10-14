import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.network({required String message, int? statusCode}) =
      NetworkFailure;

  const factory Failure.server({
    required String message,
    int? statusCode,
    String? errorCode,
  }) = ServerFailure;

  const factory Failure.auth({required String message}) = AuthFailure;

  const factory Failure.validation({
    required String message,
    Map<String, List<String>>? errors,
  }) = ValidationFailure;

  const factory Failure.unknown({required String message, dynamic error}) =
      UnknownFailure;

  const factory Failure.cache({required String message}) = CacheFailure;

  const factory Failure.timeout({required String message}) = TimeoutFailure;

  const factory Failure.client({required String message, int? statusCode}) =
      ClientFailure;
}

extension FailureX on Failure {
  String get displayMessage {
    return when(
      network: (message, statusCode) => message,
      server: (message, statusCode, errorCode) => message,
      auth: (message) => message,
      validation: (message, errors) => message,
      unknown: (message, error) => message,
      cache: (message) => message,
      timeout: (message) => message,
      client: (message, statusCode) => message,
    );
  }

  bool get isNetworkError =>
      maybeWhen(network: (_, __) => true, orElse: () => false);

  bool get isAuthError => maybeWhen(auth: (_) => true, orElse: () => false);

  bool get isServerError =>
      maybeWhen(server: (_, __, ___) => true, orElse: () => false);

  bool get isClientError =>
      maybeWhen(client: (_, __) => true, orElse: () => false);
}
