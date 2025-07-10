import 'dart:convert';
import '../../core/network_service.dart';

class LeadStatus {
  final String id;
  final String name;
  final String color;
  final String description;

  LeadStatus({
    required this.id,
    required this.name,
    required this.color,
    required this.description,
  });

  factory LeadStatus.fromJson(Map<String, dynamic> json) => LeadStatus(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    color: json['color'] ?? '#000000',
    description: json['description'] ?? '',
  );
}

class LeadStatusRepository {
  Future<List<LeadStatus>> fetchLeadStatuses() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      final leadStatuses = jsonMap['data']['leadStatuses'] as List<dynamic>? ?? [];
      return leadStatuses.map((e) => LeadStatus.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load lead statuses: $e');
    }
  }

  Future<LeadStatus> getLeadStatusById(String id) async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      final leadStatuses = jsonMap['data']['leadStatuses'] as List<dynamic>? ?? [];
      final status = leadStatuses.firstWhere(
        (status) => status['_id'] == id || status['id'] == id,
        orElse: () => throw Exception('Lead status not found'),
      );
      return LeadStatus.fromJson(status);
    } catch (e) {
      throw Exception('Failed to load lead status: $e');
    }
  }
} 