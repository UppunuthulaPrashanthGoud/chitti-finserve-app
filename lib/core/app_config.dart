import 'package:flutter/foundation.dart';

class AppConfig {
  // API Configuration
  static String get apiBaseUrl {
    return 'http://localhost:5000/api';
  }

  // Debug information
  static void printDebugInfo() {
    print('🔧 AppConfig Debug Info:');
    print('   Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    print('   API Base URL: $apiBaseUrl');
    print('   Development Mode: $isDevelopment');
  }

  // App Configuration
  static const String appName = 'Chitti Finserv';
  static const String appVersion = '1.0.0';
  
  // Timeout Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Feature Flags
  static const bool enableDebugMode = true;
  static const bool enableLogging = true;
  
  // Development vs Production
  static bool get isDevelopment => true; // Change to false for production
  static bool get isProduction => !isDevelopment;
} 