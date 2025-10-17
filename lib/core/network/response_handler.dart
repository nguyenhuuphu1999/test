import 'package:dio/dio.dart';
import '../error/result.dart';
import '../error/failures.dart';

/// Utility class for handling API responses consistently
class ResponseHandler {
  /// Handle API response and extract data based on common response formats
  static Result<T> handleResponse<T>(
    Response response,
    T Function(dynamic data) mapper, {
    bool handleWrappedResponse = true,
  }) {
    try {
      if (response.data == null) {
        return Err(UnknownFailure(message: 'Response data is null'));
      }

      dynamic data = response.data;

      // Handle wrapped response format: {data: {...}, message: "...", success: true}
      if (handleWrappedResponse && data is Map<String, dynamic>) {
        final responseMap = data;
        
        // Check for error in wrapped response
        if (responseMap.containsKey('success') && responseMap['success'] == false) {
          final errorMessage = responseMap['message'] ?? 'Unknown error';
          return Err(ServerFailure(message: errorMessage));
        }
        
        // Extract data from wrapped response
        if (responseMap.containsKey('data')) {
          data = responseMap['data'];
        }
      }

      final result = mapper(data);
      return Ok(result);
    } catch (e) {
      return Err(UnknownFailure(message: 'Failed to parse response: $e'));
    }
  }

  /// Handle list response with automatic type conversion
  static Result<List<T>> handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) mapper, {
    bool handleWrappedResponse = true,
  }) {
    return handleResponse<List<T>>(
      response,
      (data) {
        List<dynamic> listData;
        
        if (data is List) {
          listData = data;
        } else if (data is Map<String, dynamic>) {
          // Handle single object by wrapping in list
          listData = [data];
        } else {
          throw Exception('Expected List or Map, got ${data.runtimeType}');
        }

        return listData
            .map((item) => mapper(item as Map<String, dynamic>))
            .toList();
      },
      handleWrappedResponse: handleWrappedResponse,
    );
  }

  /// Handle paginated response
  static Result<(List<T>, int, int, int)> handlePaginatedResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) mapper, {
    bool handleWrappedResponse = true,
  }) {
    return handleResponse<(List<T>, int, int, int)>(
      response,
      (data) {
        if (data is! Map<String, dynamic>) {
          throw Exception('Expected Map for paginated response, got ${data.runtimeType}');
        }

        final responseMap = data;
        
        // Handle different pagination formats
        List<dynamic> items;
        int currentPage = 1;
        int totalPages = 1;
        int totalItems = 0;

        if (responseMap.containsKey('list') || responseMap.containsKey('items')) {
          // Format: {list: [...], currentPage: 1, totalPages: 1, totalItems: 0}
          final listData = responseMap['list'] ?? responseMap['items'];
          items = listData is List<dynamic> ? listData : <dynamic>[];
          currentPage = responseMap['currentPage'] ?? responseMap['page'] ?? 1;
          totalPages = responseMap['totalPages'] ?? responseMap['total_pages'] ?? 1;
          totalItems = responseMap['totalItems'] ?? responseMap['total'] ?? responseMap['total_items'] ?? 0;
        } else if (responseMap.containsKey('data')) {
          // Nested format: {data: {list: [...], currentPage: 1, ...}}
          final dataMap = responseMap['data'] as Map<String, dynamic>;
          final listData = dataMap['list'] ?? dataMap['items'];
          items = listData is List<dynamic> ? listData : <dynamic>[];
          currentPage = dataMap['currentPage'] ?? dataMap['page'] ?? 1;
          totalPages = dataMap['totalPages'] ?? dataMap['total_pages'] ?? 1;
          totalItems = dataMap['totalItems'] ?? dataMap['total'] ?? dataMap['total_items'] ?? 0;
        } else {
          // Assume the entire response is a list or single object
          if (responseMap is List<dynamic>) {
            items = responseMap as List<dynamic>;
          } else {
            // If it's a single object or other type, wrap it in a list
            items = <dynamic>[responseMap];
          }
        }

        final mappedItems = items
            .map((item) => mapper(item as Map<String, dynamic>))
            .toList();

        return (mappedItems, currentPage, totalPages, totalItems);
      },
      handleWrappedResponse: handleWrappedResponse,
    );
  }

  /// Handle DioException with proper error mapping
  static Result<T> handleDioException<T>(DioException e) {
    if (e.response?.statusCode != null) {
      final statusCode = e.response!.statusCode!;
      final message = _extractErrorMessage(e.response!.data);
      
      if (statusCode >= 400 && statusCode < 500) {
        return Err(ClientFailure(
          message: message,
          statusCode: statusCode,
        ));
      } else if (statusCode >= 500) {
        return Err(ServerFailure(
          message: message,
          statusCode: statusCode,
        ));
      }
    }

    // Handle network errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Err(NetworkFailure(message: 'Request timeout'));
    }

    if (e.type == DioExceptionType.connectionError) {
      return Err(NetworkFailure(message: 'Connection error'));
    }

    if (e.type == DioExceptionType.badCertificate) {
      return Err(NetworkFailure(message: 'SSL certificate error'));
    }

    return Err(UnknownFailure(message: e.message ?? 'Unknown error'));
  }

  /// Extract error message from response data
  static String _extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error';
    
    if (data is String) return data;
    
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      return data['message'] ?? 
             data['error'] ?? 
             data['detail'] ?? 
             data['description'] ?? 
             'Unknown error';
    }
    
    return data.toString();
  }
}
