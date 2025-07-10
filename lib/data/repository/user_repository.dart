import 'dart:convert';
import '../../core/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return json.decode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await NetworkService.get('/auth/me', token: token);
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await NetworkService.put(
        '/auth/profile',
        body: profileData,
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await NetworkService.put(
        '/auth/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        token: token,
      );
      NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
} 