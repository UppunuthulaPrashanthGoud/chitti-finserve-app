import 'app_config.dart';

class ImageUtils {
  /// Constructs a full image URL from a relative path
  /// Handles both network URLs and relative paths
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      if (AppConfig.enableLogging) {
        print('🔧 ImageUtils Warning: Empty or null image path');
      }
      return '';
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      if (AppConfig.enableLogging) {
        print('🔧 ImageUtils: Using full URL as is: $imagePath');
      }
      return imagePath;
    }

    // If it's a local asset, return as is
    if (imagePath.startsWith('assets/')) {
      if (AppConfig.enableLogging) {
        print('🔧 ImageUtils: Using local asset: $imagePath');
      }
      return imagePath;
    }

    // For backend uploads, construct the full URL
    // Remove any leading slash from image path
    String cleanImagePath = imagePath;
    if (cleanImagePath.startsWith('/')) {
      cleanImagePath = cleanImagePath.substring(1);
    }

    // Ensure base URL doesn't end with slash and image path doesn't start with slash
    final baseUrl = AppConfig.assetsBaseUrl.endsWith('/')
        ? AppConfig.assetsBaseUrl.substring(0, AppConfig.assetsBaseUrl.length - 1)
        : AppConfig.assetsBaseUrl;

    final fullUrl = '$baseUrl/$cleanImagePath';
    
    // Debug logging
    if (AppConfig.enableLogging) {
      print('🔧 ImageUtils Debug:');
      print('   Original path: $imagePath');
      print('   Clean path: $cleanImagePath');
      print('   Base URL: $baseUrl');
      print('   Final URL: $fullUrl');
      print('   URL length: ${fullUrl.length}');
    }

    return fullUrl;
  }

  /// Checks if an image path is a network image
  static bool isNetworkImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }
    return imagePath.startsWith('http://') || 
           imagePath.startsWith('https://') || 
           imagePath.startsWith('uploads/');
  }

  /// Checks if an image path is a local asset
  static bool isAssetImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }
    return imagePath.startsWith('assets/');
  }
} 