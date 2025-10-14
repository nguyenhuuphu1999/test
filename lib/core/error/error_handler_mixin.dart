import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'result.dart';

mixin ErrorHandlerMixin<T extends StatefulWidget> on State<T> {
  /// Handle API result with automatic error display
  void handleApiResult<R>(
    Result<R> result, {
    required Function(R data) onSuccess,
    VoidCallback? onRetry,
    String? customErrorMessage,
  }) {
    result.when(
      ok: (data) => onSuccess(data),
      err: (failure) => ErrorHandler.handleError(
        context,
        failure,
        customMessage: customErrorMessage,
        onRetry: onRetry,
      ),
    );
  }

  /// Handle API result with success message
  void handleApiResultWithSuccess<R>(
    Result<R> result, {
    required Function(R data) onSuccess,
    required String successMessage,
    VoidCallback? onRetry,
    String? customErrorMessage,
  }) {
    result.when(
      ok: (data) {
        onSuccess(data);
        ErrorHandler.showSuccessMessage(context, successMessage);
      },
      err: (failure) => ErrorHandler.handleError(
        context,
        failure,
        customMessage: customErrorMessage,
        onRetry: onRetry,
      ),
    );
  }

  /// Handle async operation with error display
  Future<void> handleAsyncOperation<R>(
    Future<Result<R>> operation, {
    required Function(R data) onSuccess,
    VoidCallback? onRetry,
    String? customErrorMessage,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      // You can show loading indicator here if needed
    }

    try {
      final result = await operation;
      handleApiResult(
        result,
        onSuccess: onSuccess,
        onRetry: onRetry,
        customErrorMessage: customErrorMessage,
      );
    } catch (e) {
      ErrorHandler.handleError(
        context,
        e,
        customMessage: customErrorMessage,
        onRetry: onRetry,
      );
    }
  }

  /// Show success message
  void showSuccess(String message) {
    ErrorHandler.showSuccessMessage(context, message);
  }

  /// Show warning message
  void showWarning(String message) {
    ErrorHandler.showWarningMessage(context, message);
  }

  /// Show error dialog
  void showError(
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    ErrorHandler.handleError(
      context,
      error,
      customMessage: customMessage,
      onRetry: onRetry,
    );
  }
}
