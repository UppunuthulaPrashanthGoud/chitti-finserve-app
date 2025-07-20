import 'dart:convert';
import '../../core/network_service.dart';
import '../model/bank_model.dart';

class BankRepository {
  Future<List<BankModel>> getBanks() async {
    try {
      final response = await NetworkService.get('/banks');
      final jsonMap = NetworkService.parseResponse(response);
      
      // Handle different response structures
      List<dynamic> banksData;
      if (jsonMap['data'] != null) {
        banksData = jsonMap['data'] as List<dynamic>;
      } else if (jsonMap is List) {
        banksData = jsonMap as List<dynamic>;
      } else {
        throw Exception('Invalid response format for banks');
      }
      
      return banksData.map((e) => BankModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load banks: $e');
    }
  }

  Future<List<BankModel>> getActiveBanks() async {
    try {
      final allBanks = await getBanks();
      return allBanks.where((bank) => bank.isActive == true).toList();
    } catch (e) {
      throw Exception('Failed to load active banks: $e');
    }
  }
} 