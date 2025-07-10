import 'dart:convert';
import '../../core/network_service.dart';
import '../model/login_model.dart';

class LoginRepository {
  Future<LoginModel> fetchLoginConfig() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return LoginModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load login config: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await NetworkService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> sendOTP(String phone) async {
    try {
      final response = await NetworkService.post(
        '/auth/send-otp',
        body: {
          'phone': phone,
        },
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    try {
      final response = await NetworkService.post(
        '/auth/verify-otp',
        body: {
          'phone': phone,
          'otp': otp,
        },
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String phone, String password) async {
    try {
      final response = await NetworkService.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
