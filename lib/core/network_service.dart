import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_config.dart';

class NetworkService {
  static String get baseUrl => AppConfig.apiBaseUrl;
  static Duration get timeout => AppConfig.apiTimeout;
  static int get maxRetries => AppConfig.maxRetries;

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    return _makeRequest(
      () => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(headers, token),
      ),
    );
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return _makeRequest(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(headers, token),
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return _makeRequest(
      () => http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(headers, token),
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    return _makeRequest(
      () => http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(headers, token),
      ),
    );
  }

  static Map<String, String> _buildHeaders(
    Map<String, String>? headers,
    String? token,
  ) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
      if (AppConfig.enableLogging) {
        print('🔐 NetworkService: Adding Authorization header with token');
      }
    } else {
      if (AppConfig.enableLogging) {
        print('⚠️ NetworkService: No token provided for request');
      }
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  static Future<http.Response> _makeRequest(
    Future<http.Response> Function() request,
  ) async {
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        if (AppConfig.enableLogging) {
          print('🌐 NetworkService: Making request (attempt ${retryCount + 1})');
        }
        
        final response = await request().timeout(timeout);
        
        if (AppConfig.enableLogging) {
          print('✅ NetworkService: Response received - Status: ${response.statusCode}');
        }
        
        // If successful, return the response
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // If it's a client error (4xx), don't retry
        if (response.statusCode >= 400 && response.statusCode < 500) {
          if (AppConfig.enableLogging) {
            print('❌ NetworkService: Client error - Status: ${response.statusCode}');
          }
          return response;
        }
        
        // If it's a server error (5xx), retry
        if (response.statusCode >= 500) {
          retryCount++;
          if (AppConfig.enableLogging) {
            print('🔄 NetworkService: Server error, retrying... ($retryCount/$maxRetries)');
          }
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount * 2));
            continue;
          }
        }
        
        return response;
      } catch (e) {
        retryCount++;
        
        if (AppConfig.enableLogging) {
          print('❌ NetworkService: Error occurred - $e');
          print('🔄 NetworkService: Retrying... ($retryCount/$maxRetries)');
        }
        
        // If it's a network error, retry
        if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount * 2));
            continue;
          }
        }
        
        // If it's a timeout, retry
        if (e.toString().contains('timeout')) {
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount * 2));
            continue;
          }
        }
        
        // If we've exhausted retries or it's not a retryable error, rethrow
        rethrow;
      }
    }
    
    throw Exception('Request failed after $maxRetries retries');
  }

  static Map<String, dynamic> parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      
      // Handle validation errors specifically
      if (response.statusCode == 400 && errorBody['errors'] != null) {
        final errors = errorBody['errors'] as List;
        final validationMessages = errors.map((error) => error['msg'] ?? 'Validation error').join(', ');
        throw ApiException(
          message: validationMessages,
          statusCode: response.statusCode,
          data: errorBody,
        );
      }
      
      // Handle other errors
      throw ApiException(
        message: errorBody['message'] ?? 'Request failed',
        statusCode: response.statusCode,
        data: errorBody,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
} 