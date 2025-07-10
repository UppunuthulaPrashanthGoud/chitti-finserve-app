import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkService {
  static const String baseUrl = 'http://localhost:5000/api';
  // For production: 'https://your-domain.com/api'
  
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;

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
        final response = await request().timeout(timeout);
        
        // If successful, return the response
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // If it's a client error (4xx), don't retry
        if (response.statusCode >= 400 && response.statusCode < 500) {
          return response;
        }
        
        // If it's a server error (5xx), retry
        if (response.statusCode >= 500) {
          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount * 2));
            continue;
          }
        }
        
        return response;
      } catch (e) {
        retryCount++;
        
        // If it's a network error, retry
        if (e is SocketException || e is HttpException) {
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
  String toString() => 'ApiException: $message (Status: $statusCode)';
} 