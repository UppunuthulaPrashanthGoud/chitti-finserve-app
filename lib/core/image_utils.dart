import 'app_config.dart';

class ImageUtils {
  /// Constructs a full image URL from a relative path
  /// Handles both network URLs and relative paths
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // If it's a local asset, return as is
    if (imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // For backend uploads, construct the full URL
    // Get base URL and ensure it doesn't end with slash
    String baseUrl = AppConfig.assetsBaseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    // Clean the image path - remove leading slash if present
    String cleanImagePath = imagePath;
    if (cleanImagePath.startsWith('/')) {
      cleanImagePath = cleanImagePath.substring(1);
    }

    // Construct the full URL properly
    final fullUrl = '$baseUrl/$cleanImagePath';
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