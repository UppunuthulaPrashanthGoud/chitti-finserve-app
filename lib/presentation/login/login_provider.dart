import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/login_repository.dart';
import '../../data/repository/user_repository.dart';
import '../../data/model/login_model.dart';
import '../user/user_provider.dart';

final loginConfigProvider = FutureProvider.autoDispose<LoginModel>((ref) async {
  final repo = LoginRepository();
  return repo.fetchLoginConfig();
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

final loginStateProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final repository = ref.read(loginRepositoryProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return LoginNotifier(repository, userRepository, ref);
});

class LoginState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? userData;
  final bool isAuthenticated;

  LoginState({
    this.isLoading = false,
    this.error,
    this.userData,
    this.isAuthenticated = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? userData,
    bool? isAuthenticated,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userData: userData ?? this.userData,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginRepository _repository;
  final UserRepository _userRepository;
  final Ref _ref;

  LoginNotifier(this._repository, this._userRepository, this._ref) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _repository.login(email, password);
      final token = result['token'] as String;
      final userData = result['data'] as Map<String, dynamic>;
      
      // Save token and user data
      await _userRepository.saveAuthToken(token);
      await _userRepository.saveUserData(userData);
      
      // Update auth state
      await _ref.read(authStateProvider.notifier).login(email, password);
      
      state = state.copyWith(
        isLoading: false,
        userData: userData,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendOTP(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.sendOTP(phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> verifyOTP(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _repository.verifyOTP(phone, otp);
      final token = result['token'] as String;
      final userData = result['data'] as Map<String, dynamic>;
      
      // Save token and user data
      await _userRepository.saveAuthToken(token);
      await _userRepository.saveUserData(userData);
      
      // Update auth state
      await _ref.read(authStateProvider.notifier).login(phone, otp);
      
      state = state.copyWith(
        isLoading: false,
        userData: userData,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(String name, String email, String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _repository.register(name, email, phone, password);
      final token = result['token'] as String;
      final userData = result['data'] as Map<String, dynamic>;
      
      // Save token and user data
      await _userRepository.saveAuthToken(token);
      await _userRepository.saveUserData(userData);
      
      // Update auth state
      await _ref.read(authStateProvider.notifier).login(email, password);
      
      state = state.copyWith(
        isLoading: false,
        userData: userData,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    _userRepository.clearAuthData();
    _ref.read(authStateProvider.notifier).logout();
    state = LoginState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
