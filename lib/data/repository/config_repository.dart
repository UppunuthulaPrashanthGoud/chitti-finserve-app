import 'dart:convert';
import '../../core/network_service.dart';

class AppConfig {
  final Map<String, dynamic> splash;
  final Map<String, dynamic> login;
  final Map<String, dynamic> loanForm;
  final Map<String, dynamic> contact;
  final List<Map<String, dynamic>> leadStatuses;
  final Map<String, dynamic> notifications;
  final Map<String, dynamic> legal;

  AppConfig({
    required this.splash,
    required this.login,
    required this.loanForm,
    required this.contact,
    required this.leadStatuses,
    required this.notifications,
    required this.legal,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    splash: json['splash'] ?? {},
    login: json['login'] ?? {},
    loanForm: json['loanForm'] ?? {},
    contact: json['contact'] ?? {},
    leadStatuses: List<Map<String, dynamic>>.from(json['leadStatuses'] ?? []),
    notifications: json['notifications'] ?? {},
    legal: json['legal'] ?? {},
  );
}

class ConfigRepository {
  Future<AppConfig> fetchAppConfig() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return AppConfig.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load app config: $e');
    }
  }

  Future<Map<String, dynamic>> getLegalPages() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data']['legal'] ?? {};
    } catch (e) {
      throw Exception('Failed to load legal pages: $e');
    }
  }

  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data']['notifications'] ?? {};
    } catch (e) {
      throw Exception('Failed to load notification settings: $e');
    }
  }
} 