import 'dart:io';
import 'package:http/http.dart' as http;
import 'image_utils.dart';

class NetworkTest {
  /// Test if an image URL is accessible
  static Future<bool> testImageUrl(String imagePath) async {
    try {
      final url = ImageUtils.getImageUrl(imagePath);
      if (url.isEmpty) {
        print('🔧 NetworkTest: Empty URL for image path: $imagePath');
        return false;
      }

      print('🔧 NetworkTest: Testing URL: $url');
      
      final response = await http.head(Uri.parse(url), headers: {
        'Accept': 'image/*',
        'User-Agent': 'Flutter/1.0',
      }).timeout(const Duration(seconds: 10));

      print('🔧 NetworkTest: Response status: ${response.statusCode}');
      print('🔧 NetworkTest: Response headers: ${response.headers}');

      return response.statusCode == 200;
    } catch (e) {
      print('🔧 NetworkTest: Error testing URL: $e');
      return false;
    }
  }

  /// Test multiple image URLs
  static Future<Map<String, bool>> testImageUrls(List<String> imagePaths) async {
    final results = <String, bool>{};
    
    for (final path in imagePaths) {
      results[path] = await testImageUrl(path);
    }
    
    return results;
  }
} 