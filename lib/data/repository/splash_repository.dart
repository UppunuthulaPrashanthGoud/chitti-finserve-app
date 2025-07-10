import 'dart:convert';
import '../../core/network_service.dart';

class SplashContent {
  final String logo;
  final String tagline;

  SplashContent({required this.logo, required this.tagline});

  factory SplashContent.fromJson(Map<String, dynamic> json) =>
      SplashContent(
        logo: json['logo'] ?? '',
        tagline: json['tagline'] ?? '',
      );
}

class SplashRepository {
  Future<SplashContent> fetchSplashContent() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return SplashContent.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load splash content: $e');
    }
  }
}
