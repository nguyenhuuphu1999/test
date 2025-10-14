import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    String message;
    String title = 'Error';

    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      switch (statusCode) {
        case 400:
          title = 'Bad Request';
          message =
              _extractMessage(responseData) ??
              'Invalid request. Please check your input.';
          break;
        case 401:
          title = 'Unauthorized';
          message =
              _extractMessage(responseData) ??
              'You are not authorized to perform this action.';
          break;
        case 403:
          title = 'Forbidden';
          message =
              _extractMessage(responseData) ??
              'Access denied. You don\'t have permission.';
          break;
        case 404:
          title = 'Not Found';
          message =
              _extractMessage(responseData) ??
              'The requested resource was not found.';
          break;
        case 408:
          title = 'Request Timeout';
          message =
              _extractMessage(responseData) ??
              'Request timed out. Please try again.';
          break;
        case 409:
          title = 'Conflict';
          message =
              _extractMessage(responseData) ??
              'There was a conflict with the current state.';
          break;
        case 422:
          title = 'Validation Error';
          message =
              _extractMessage(responseData) ??
              'Please check your input and try again.';
          break;
        case 429:
          title = 'Too Many Requests';
          message =
              _extractMessage(responseData) ??
              'Too many requests. Please wait and try again.';
          break;
        case 500:
          title = 'Server Error';
          message =
              _extractMessage(responseData) ??
              'Internal server error. Please try again later.';
          break;
        case 502:
          title = 'Bad Gateway';
          message =
              _extractMessage(responseData) ??
              'Server is temporarily unavailable.';
          break;
        case 503:
          title = 'Service Unavailable';
          message =
              _extractMessage(responseData) ??
              'Service is temporarily unavailable.';
          break;
        case 504:
          title = 'Gateway Timeout';
          message =
              _extractMessage(responseData) ??
              'Server took too long to respond.';
          break;
        default:
          if (statusCode != null && statusCode >= 400) {
            title = 'Request Failed';
            message =
                _extractMessage(responseData) ??
                'Request failed with status $statusCode.';
          } else {
            title = 'Network Error';
            message =
                _extractMessage(responseData) ??
                'Network connection error. Please check your internet connection.';
          }
      }
    } else if (error is Failure) {
      title = 'Error';
      message = error.message;
    } else if (error is String) {
      message = error;
    } else {
      title = 'Unexpected Error';
      message =
          customMessage ?? 'An unexpected error occurred. Please try again.';
    }

    _showErrorDialog(context, title, message, onRetry: onRetry);
  }

  static String? _extractMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      // Try common error message fields
      return responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['detail'] as String? ??
          responseData['msg'] as String?;
    }

    if (responseData is String) {
      return responseData;
    }

    return null;
  }

  static void _showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSuccessMessage(
    BuildContext context,
    String message, {
    String title = 'Success',
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showWarningMessage(
    BuildContext context,
    String message, {
    String title = 'Warning',
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_outlined, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
