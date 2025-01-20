// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'YOUR_API_BASE_URL';
  static const Duration _timeout = Duration(seconds: 30);
  
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _defaultHeaders.remove('Authorization');
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await http
          .get(
            uri,
            headers: {..._defaultHeaders, ...?headers},
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http
          .post(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T?> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http
          .put(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: jsonEncode(data),
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<T?> delete<T>(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http
          .delete(
            uri,
            headers: {..._defaultHeaders, ...?headers},
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  T? _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      
      final data = jsonDecode(response.body);
      return data as T;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error: ${response.statusCode}';
    }
  }

  void _handleError(dynamic error) {
    if (error is ApiException) {
      debugPrint('API Error: ${error.message}');
    } else if (error is http.ClientException) {
      debugPrint('Network Error: ${error.message}');
    } else {
      debugPrint('Unexpected Error: $error');
    }
  }

  // Convenience methods for specific API endpoints
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await get<Map<String, dynamic>>('/users/$userId');
  }

  Future<List<Map<String, dynamic>>?> getEcoActions() async {
    return await get<List<Map<String, dynamic>>>('/eco-actions');
  }

  Future<Map<String, dynamic>?> completeEcoAction(
    String actionId,
    Map<String, dynamic> data,
  ) async {
    return await post<Map<String, dynamic>>(
      '/eco-actions/$actionId/complete',
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>?> getRewards() async {
    return await get<List<Map<String, dynamic>>>('/rewards');
  }

  Future<Map<String, dynamic>?> redeemReward(
    String rewardId,
    Map<String, dynamic> data,
  ) async {
    return await post<Map<String, dynamic>>(
      '/rewards/$rewardId/redeem',
      data: data,
    );
  }

  Future<Map<String, dynamic>?> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await put<Map<String, dynamic>>(
      '/users/$userId',
      data: data,
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

// Example usage:
/*
void main() async {
  final api = ApiService();
  
  // Set auth token after login
  api.setAuthToken('your-auth-token');
  
  try {
    // Get user profile
    final profile = await api.getUserProfile('123');
    print(profile);
    
    // Get eco actions
    final actions = await api.getEcoActions();
    print(actions);
    
    // Complete an eco action
    final result = await api.completeEcoAction(
      'action123',
      {'proof': 'image_url.jpg'},
    );
    print(result);
  } on ApiException catch (e) {
    print('API Error: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  }
}
*/