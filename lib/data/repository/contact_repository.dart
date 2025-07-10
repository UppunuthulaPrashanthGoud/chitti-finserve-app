import 'dart:convert';
import '../../core/network_service.dart';
import '../model/contact_model.dart';

class ContactRepository {
  Future<ContactModel> fetchContact() async {
    try {
      final response = await NetworkService.get('/configuration/public');
      final jsonMap = NetworkService.parseResponse(response);
      return ContactModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load contact info: $e');
    }
  }

  Future<Map<String, dynamic>> submitContactForm(Map<String, dynamic> formData) async {
    try {
      final response = await NetworkService.post(
        '/contact',
        body: formData,
      );
      return NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to submit contact form: $e');
    }
  }
}
