import 'dart:convert';
import '../../core/network_service.dart';
import '../model/loan_form_model.dart';

class LoanFormRepository {
  Future<LoanFormModel> fetchLoanFormConfig() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return LoanFormModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load loan form config: $e');
    }
  }

  Future<Map<String, dynamic>> submitLoanApplication(Map<String, dynamic> formData) async {
    try {
      final response = await NetworkService.post(
        '/loan-applications',
        body: formData,
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to submit loan application: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserApplications(String userId) async {
    try {
      final response = await NetworkService.get('/loan-applications/user/$userId');
      final jsonMap = NetworkService.parseResponse(response);
      return List<Map<String, dynamic>>.from(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load user applications: $e');
    }
  }

  Future<Map<String, dynamic>> getApplicationById(String applicationId) async {
    try {
      final response = await NetworkService.get('/loan-applications/$applicationId');
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      throw Exception('Failed to load application: $e');
    }
  }
}
