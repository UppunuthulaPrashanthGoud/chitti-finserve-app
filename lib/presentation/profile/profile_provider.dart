import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/profile_model.dart';
import '../../data/repository/profile_repository.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  return ProfileNotifier(ProfileRepository());
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String mobileNumber,
    String? emailId,
    String? loanAmount,
    String? purposeOfLoan,
    String? monthlyIncome,
    String? occupation,
    String? aadharNumber,
    String? panNumber,
    String? profilePicture,
    String? aadharUpload,
    String? panUpload,
  }) async {
    try {
      final updatedProfile = ProfileModel(
        fullName: fullName,
        mobileNumber: mobileNumber,
        emailId: emailId,
        loanAmount: loanAmount,
        purposeOfLoan: purposeOfLoan,
        monthlyIncome: monthlyIncome,
        occupation: occupation,
        aadharNumber: aadharNumber,
        panNumber: panNumber,
        profilePicture: profilePicture,
        aadharUpload: aadharUpload,
        panUpload: panUpload,
      );
      
      await _repository.updateProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
} 