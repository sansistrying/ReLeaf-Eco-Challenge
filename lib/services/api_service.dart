// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  late final Dio _dio;
  final NavigationService _navigationService;

  ApiService(this._navigationService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'YOUR_API_BASE_URL',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _handleError(e);
          return handler.next(e);
        },
      ),
    );
  }

  void _handleError(DioException error) {
    // Handle different types of errors
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // Handle timeout errors
        break;
      case DioExceptionType.badResponse:
        // Handle bad responses
        break;
      case DioExceptionType.cancel:
        // Handle cancellation
        break;
      default:
        // Handle other errors
        break;
    }
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Add other HTTP methods as needed
}

