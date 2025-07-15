import 'dart:convert';
import '../../core/network_service.dart';
import '../model/referral_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralRepository {
  static const String _tokenKey = 'auth_token';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get user's referral information
  Future<ReferralDataModel> getMyReferrals() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      print('🔑 ReferralRepository: Token found, making request to /referrals/my-referrals');
      
      final response = await NetworkService.get('/referrals/my-referrals', token: token);
      final jsonMap = NetworkService.parseResponse(response);
      return ReferralDataModel.fromJson(jsonMap['data']);
    } catch (e) {
      print('❌ ReferralRepository: Error in getMyReferrals - $e');
      throw Exception('Failed to load referral data: $e');
    }
  }

  // Verify referral code
  Future<Map<String, dynamic>> verifyReferralCode(String referralCode) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      final response = await NetworkService.post(
        '/referrals/verify',
        body: {'referralCode': referralCode},
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      throw Exception('Failed to verify referral code: $e');
    }
  }

  // Apply referral code
  Future<Map<String, dynamic>> applyReferralCode(String referralCode) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      print('🔑 ReferralRepository: Applying referral code: $referralCode');
      
      final response = await NetworkService.post(
        '/referrals/apply',
        body: {'referralCode': referralCode},
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      print('❌ ReferralRepository: Error applying referral code - $e');
      throw Exception('Failed to apply referral code: $e');
    }
  }

  // Get wallet transactions
  Future<WalletTransactionsResponseModel> getWalletTransactions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      final response = await NetworkService.get(
        '/referrals/wallet-transactions?page=$page&limit=$limit',
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      return WalletTransactionsResponseModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load wallet transactions: $e');
    }
  }

  // Request withdrawal
  Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    required String bankDetails,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      final response = await NetworkService.post(
        '/referrals/withdraw',
        body: {
          'amount': amount,
          'bankDetails': bankDetails,
        },
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      return jsonMap['data'];
    } catch (e) {
      throw Exception('Failed to request withdrawal: $e');
    }
  }

  // Get share referral data
  Future<ShareReferralModel> getShareReferralData() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Not authorized, no token');
      }

      final response = await NetworkService.get('/referrals/share', token: token);
      final jsonMap = NetworkService.parseResponse(response);
      return ShareReferralModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to get share data: $e');
    }
  }
} 
 
 