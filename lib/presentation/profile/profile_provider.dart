import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/profile_model.dart';
import '../../data/repository/profile_repository.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  final repo = ref.read(profileRepositoryProvider);
  return ProfileNotifier(repo);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final ProfileRepository _repository;
  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? aadharNumber,
    String? panNumber,
    String? profilePicture,
    String? aadharUpload,
    String? panUpload,
  }) async {
    try {
      final currentProfile = state.value;
      if (currentProfile == null) return;
      final updatedProfile = currentProfile.copyWith(
        name: name,
        email: email,
        aadharNumber: aadharNumber,
        panNumber: panNumber,
        profilePicture: profilePicture,
        aadharUpload: aadharUpload,
        panUpload: panUpload,
      );
      await _repository.updateProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> clearProfile() async {
    await _repository.clearProfile();
    state = const AsyncValue.data(null);
  }

  Future<void> uploadDocument(String documentType, String documentUrl) async {
    try {
      await _repository.uploadDocument(documentType, documentUrl);
      // Reload profile to get updated data
      await loadProfile();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
} 