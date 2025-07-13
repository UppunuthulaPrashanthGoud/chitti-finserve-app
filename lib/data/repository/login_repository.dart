import 'dart:convert';
import '../../core/network_service.dart';
import '../model/login_model.dart';

class LoginRepository {
  Future<LoginModel> fetchLoginConfig() async {
    try {


      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      
      // Validate response structure
      if (jsonMap['data'] == null) {
        throw Exception('Invalid response format from server');
      }
      
      // The login configuration is nested inside data.login
      final loginData = jsonMap['data']['login'];
      if (loginData == null) {
        throw Exception('Login configuration not found in server response');
      }
      
      try {
        final loginModel = LoginModel.fromJson(loginData);
        return loginModel;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server is taking too long to respond. Please try again.');
      } else {
        // Clean the error message by removing any "Exception:" prefix
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11); // Remove "Exception: " prefix
        }
        throw Exception('Failed to load login config: $errorMessage');
      }
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
      // Parse error response for user-friendly messages
      if (e.toString().contains('ApiException')) {
        if (e.toString().contains('Invalid credentials')) {
          throw Exception('Invalid email or password. Please try again.');
        } else if (e.toString().contains('Account is deactivated')) {
          throw Exception('Your account has been deactivated. Please contact support.');
        } else if (e.toString().contains('Please enter a valid email')) {
          throw Exception('Please enter a valid email address.');
        } else if (e.toString().contains('Password is required')) {
          throw Exception('Please enter your password.');
        } else {
          throw Exception('Login failed. Please try again.');
        }
      } else if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server is taking too long to respond. Please try again.');
      } else {
        // Clean the error message by removing any "Exception:" prefix
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11); // Remove "Exception: " prefix
        }
        throw Exception('Login failed. Please try again.');
      }
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
      // Parse error response for user-friendly messages
      if (e.toString().contains('ApiException')) {
        if (e.toString().contains('Please enter a valid 10-digit phone number')) {
          throw Exception('Please enter a valid 10-digit phone number.');
        } else if (e.toString().contains('Failed to send OTP')) {
          throw Exception('Unable to send OTP at the moment. Please try again later.');
        } else {
          throw Exception('Failed to send OTP. Please try again.');
        }
      } else if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server is taking too long to respond. Please try again.');
      } else {
        // Clean the error message by removing any "Exception:" prefix
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11); // Remove "Exception: " prefix
        }
        throw Exception('Failed to send OTP. Please try again.');
      }
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
      
      final responseData = NetworkService.parseResponse(response);
      
      // Validate response structure
      if (responseData == null) {
        throw Exception('Invalid response from server');
      }
      
      // Check if response has required fields
      if (responseData['success'] != true) {
        throw Exception('OTP verification failed');
      }
      
      if (responseData['data'] == null) {
        throw Exception('Invalid response format from server');
      }
      
      final data = responseData['data'] as Map<String, dynamic>;
      
      // Validate required fields
      if (data['token'] == null) {
        throw Exception('Authentication token not received');
      }
      
      if (data['user'] == null) {
        throw Exception('User data not received');
      }
      
      return responseData;
    } catch (e) {
      // Parse error response for user-friendly messages
      if (e.toString().contains('ApiException')) {
        if (e.toString().contains('Invalid OTP')) {
          throw Exception('The OTP you entered is incorrect. Please try again.');
        } else if (e.toString().contains('OTP has expired')) {
          throw Exception('Your OTP has expired. Please request a new one.');
        } else if (e.toString().contains('User not found')) {
          throw Exception('No account found with this phone number. Please send OTP first.');
        } else if (e.toString().contains('OTP must be 6 digits')) {
          throw Exception('Please enter a 6-digit OTP.');
        } else if (e.toString().contains('Please enter a valid 10-digit phone number')) {
          throw Exception('Please enter a valid 10-digit phone number.');
        } else {
          throw Exception('OTP verification failed. Please try again.');
        }
      } else if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server is taking too long to respond. Please try again.');
      } else {
        // Clean the error message by removing any "Exception:" prefix
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11); // Remove "Exception: " prefix
        }
        throw Exception('OTP verification failed. Please try again.');
      }
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
      // Parse error response for user-friendly messages
      if (e.toString().contains('ApiException')) {
        if (e.toString().contains('User with this email or phone number already exists')) {
          throw Exception('An account with this email or phone number already exists.');
        } else if (e.toString().contains('Name is required')) {
          throw Exception('Please enter your full name.');
        } else if (e.toString().contains('Email is required')) {
          throw Exception('Please enter your email address.');
        } else if (e.toString().contains('Phone number is required')) {
          throw Exception('Please enter your phone number.');
        } else if (e.toString().contains('Password is required')) {
          throw Exception('Please enter a password.');
        } else if (e.toString().contains('Please enter a valid email')) {
          throw Exception('Please enter a valid email address.');
        } else if (e.toString().contains('Please enter a valid 10-digit phone number')) {
          throw Exception('Please enter a valid 10-digit phone number.');
        } else if (e.toString().contains('Password must be at least 6 characters')) {
          throw Exception('Password must be at least 6 characters long.');
        } else {
          throw Exception('Registration failed. Please try again.');
        }
      } else if (e.toString().contains('SocketException') || e.toString().contains('HttpException')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server is taking too long to respond. Please try again.');
      } else {
        throw Exception('Registration failed. Please try again.');
      }
    }
  }
}
