import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vpncn2_app/core/error/error_handler.dart';
import 'package:vpncn2_app/core/error/error_handler_mixin.dart';
import 'package:vpncn2_app/core/error/failures.dart';

/// Demo widget to showcase error handling capabilities
/// This can be used for testing different error scenarios
class ErrorHandlingDemo extends StatefulWidget {
  const ErrorHandlingDemo({super.key});

  @override
  State<ErrorHandlingDemo> createState() => _ErrorHandlingDemoState();
}

class _ErrorHandlingDemoState extends State<ErrorHandlingDemo>
    with ErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Different Error Scenarios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Network Error
            ElevatedButton(
              onPressed: () => _testNetworkError(),
              child: const Text('Test Network Error'),
            ),
            const SizedBox(height: 10),

            // 400 Bad Request
            ElevatedButton(
              onPressed: () => _test400Error(),
              child: const Text('Test 400 Bad Request'),
            ),
            const SizedBox(height: 10),

            // 401 Unauthorized
            ElevatedButton(
              onPressed: () => _test401Error(),
              child: const Text('Test 401 Unauthorized'),
            ),
            const SizedBox(height: 10),

            // 403 Forbidden
            ElevatedButton(
              onPressed: () => _test403Error(),
              child: const Text('Test 403 Forbidden'),
            ),
            const SizedBox(height: 10),

            // 404 Not Found
            ElevatedButton(
              onPressed: () => _test404Error(),
              child: const Text('Test 404 Not Found'),
            ),
            const SizedBox(height: 10),

            // 422 Validation Error
            ElevatedButton(
              onPressed: () => _test422Error(),
              child: const Text('Test 422 Validation Error'),
            ),
            const SizedBox(height: 10),

            // 500 Server Error
            ElevatedButton(
              onPressed: () => _test500Error(),
              child: const Text('Test 500 Server Error'),
            ),
            const SizedBox(height: 10),

            // Success Message
            ElevatedButton(
              onPressed: () => _testSuccessMessage(),
              child: const Text('Test Success Message'),
            ),
            const SizedBox(height: 10),

            // Warning Message
            ElevatedButton(
              onPressed: () => _testWarningMessage(),
              child: const Text('Test Warning Message'),
            ),
            const SizedBox(height: 10),

            // Custom Error with Retry
            ElevatedButton(
              onPressed: () => _testCustomErrorWithRetry(),
              child: const Text('Test Custom Error with Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _testNetworkError() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.connectionError,
      message: 'No internet connection',
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test400Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 400,
        data: {'message': 'Invalid request parameters'},
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test401Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 401,
        data: {'message': 'Authentication required'},
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test403Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 403,
        data: {'message': 'Access denied'},
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test404Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 404,
        data: {'message': 'Resource not found'},
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test422Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 422,
        data: {
          'message': 'Validation failed',
          'errors': {
            'email': ['Email is required', 'Email format is invalid'],
            'password': ['Password must be at least 8 characters'],
          },
        },
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _test500Error() {
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 500,
        data: {'message': 'Internal server error'},
      ),
    );
    ErrorHandler.handleError(context, dioException);
  }

  void _testSuccessMessage() {
    ErrorHandler.showSuccessMessage(
      context,
      'Operation completed successfully!',
    );
  }

  void _testWarningMessage() {
    ErrorHandler.showWarningMessage(context, 'This is a warning message');
  }

  void _testCustomErrorWithRetry() {
    final failure = Failure.client(
      message: 'Failed to load data. Please try again.',
      statusCode: 400,
    );
    ErrorHandler.handleError(
      context,
      failure,
      onRetry: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retrying...'),
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }
}
