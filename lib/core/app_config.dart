import 'package:flutter/foundation.dart';

class AppConfig {
  // API Configuration
  // Environment
  static String Environment = 'dev';
  // dev local base url
  static String Local_URL = 'http://localhost:5000/api';
  // dev assets url
  static String Local_Assets_URL = 'http://localhost:5000';
  // prod base url
  static String Prod_URL = 'https://api.chittifinserv.com/api';
  // prod assets url
  static String Prod_Assets_URL = 'https://api.chittifinserv.com';

  static String get apiBaseUrl {
    if (Environment == 'dev') {
      return Local_URL;
    } else {
      return Prod_URL;
    }
  }

  // Assets Base URL (for images, uploads, etc.)
  static String get assetsBaseUrl {
    if (Environment == 'dev') {
      return Local_Assets_URL;
    } else {
      return Prod_Assets_URL;
    }
  }

  // Debug information
  static void printDebugInfo() {
    if (enableLogging) {
      print('🔧 AppConfig Debug Info:');
      print('   Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
      print('   API Base URL: $apiBaseUrl');
      print('   Development Mode: $isDevelopment');
    }
  }

  // App Configuration
  static const String appName = 'Chitti Finserv';
  static const String appVersion = '1.0.0';
  
  // Timeout Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Feature Flags
  static const bool enableDebugMode = false; // Disabled for production
  static bool get enableLogging => isDevelopment && enableDebugMode; // Only enable in development
  
  // Development vs Production
  static bool get isDevelopment => Environment == 'dev'; // Based on environment
  static bool get isProduction => !isDevelopment;

  // Document upload debug logging (can be enabled independently)
  static const bool enableUploadDebugLogging = false;
} 