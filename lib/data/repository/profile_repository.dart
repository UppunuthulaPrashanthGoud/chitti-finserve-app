import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  static const String _profileKey = 'user_profile';

  Future<ProfileModel?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final jsonMap = json.decode(profileJson) as Map<String, dynamic>;
        return ProfileModel.fromJson(jsonMap);
      }
      
      // Return default profile if none exists
      return ProfileModel(
        fullName: '',
        mobileNumber: '',
      );
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
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
} 