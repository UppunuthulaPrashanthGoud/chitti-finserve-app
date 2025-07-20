import 'dart:convert';
import '../../core/network_service.dart';
import '../model/state_model.dart';

class StateRepository {
  Future<List<StateModel>> getStates() async {
    try {
      final response = await NetworkService.get('/states');
      final jsonMap = NetworkService.parseResponse(response);
      
      // Handle different response structures
      List<dynamic> statesData;
      if (jsonMap['data'] != null) {
        statesData = jsonMap['data'] as List<dynamic>;
      } else if (jsonMap is List) {
        statesData = jsonMap as List<dynamic>;
      } else {
        throw Exception('Invalid response format for states');
      }
      
      return statesData.map((e) => StateModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<List<StateModel>> getActiveStates() async {
    try {
      final allStates = await getStates();
      return allStates.where((state) => state.isActive == true).toList();
    } catch (e) {
      throw Exception('Failed to load active states: $e');
    }
  }
} 