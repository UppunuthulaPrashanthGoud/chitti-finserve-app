import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return AuthNotifier(repository);
});

final currentUserProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.isAuthenticated && authState.userData != null) {
    return authState.userData;
  }
  return null;
});

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final Map<String, dynamic>? userData;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userData,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    Map<String, dynamic>? userData,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userData: userData ?? this.userData,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isAuthenticated = await _repository.isAuthenticated();
      if (isAuthenticated) {
        final userData = await _repository.getUserData();
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userData: userData,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // This would be called from the login provider after successful login
      final userData = await _repository.getCurrentUser();
      await _repository.saveUserData(userData);
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userData: userData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _repository.clearAuthData();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedUserData = await _repository.updateProfile(profileData);
      await _repository.saveUserData(updatedUserData);
      
      state = state.copyWith(
        isLoading: false,
        userData: updatedUserData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.changePassword(currentPassword, newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
} 