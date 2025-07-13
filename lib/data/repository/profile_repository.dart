import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network_service.dart';
import '../model/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ProfileRepository());

class ProfileRepository {
  static const String _profileKey = 'user_profile';

  Future<ProfileModel?> getProfile() async {
    try {
      // First try to get from backend
      final token = await _getAuthToken();
      if (token != null) {
        try {
          final response = await NetworkService.get('/auth/me', token: token);
          final jsonMap = NetworkService.parseResponse(response);
          final userData = jsonMap['data'];
          // Convert backend user data to ProfileModel
          final profile = ProfileModel(
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            profilePicture: userData['profilePicture'] ?? '',
            aadharNumber: userData['aadharNumber'] ?? '',
            aadharUpload: userData['aadharUpload'] ?? '',
            panNumber: userData['panNumber'] ?? '',
            panUpload: userData['panUpload'] ?? '',
          );
          // Save to local storage as backup
          await _saveToLocalStorage(profile);
          return profile;
        } catch (e) {
          // If backend fails, try local storage
          return await _getFromLocalStorage();
        }
      }
      // If no token, try local storage
      return await _getFromLocalStorage();
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Build request body with only non-empty values
      final Map<String, dynamic> body = {};
      
      if (profile.name != null && profile.name!.isNotEmpty) {
        body['name'] = profile.name;
      }
      if (profile.email != null && profile.email!.isNotEmpty) {
        body['email'] = profile.email;
      }
      if (profile.aadharNumber != null && profile.aadharNumber!.isNotEmpty) {
        body['aadharNumber'] = profile.aadharNumber;
      }
      if (profile.panNumber != null && profile.panNumber!.isNotEmpty) {
        body['panNumber'] = profile.panNumber;
      }
      if (profile.aadharUpload != null && profile.aadharUpload!.isNotEmpty) {
        body['aadharUpload'] = profile.aadharUpload;
      }
      if (profile.panUpload != null && profile.panUpload!.isNotEmpty) {
        body['panUpload'] = profile.panUpload;
      }
      if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
        body['profilePicture'] = profile.profilePicture;
      }
      
      // Update profile on backend
      final response = await NetworkService.put(
        '/auth/profile',
        body: body,
        token: token,
      );
      final jsonMap = NetworkService.parseResponse(response);
      // Update local storage with new data
      await _saveToLocalStorage(profile);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> uploadDocument(String documentType, String documentUrl) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      final response = await NetworkService.post(
        '/auth/upload-document',
        body: {
          'documentType': documentType,
          'documentUrl': documentUrl,
        },
        token: token,
      );
      NetworkService.parseResponse(response);
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<void> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (e) {
      throw Exception('Failed to clear profile: $e');
    }
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<ProfileModel?> _getFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      if (profileJson != null) {
        final jsonMap = json.decode(profileJson) as Map<String, dynamic>;
        return ProfileModel.fromJson(jsonMap);
      }
      // Return default profile if none exists
      return ProfileModel();
    } catch (e) {
      return ProfileModel();
    }
  }

  Future<void> _saveToLocalStorage(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      // Ignore local storage errors
    }
  }
} 