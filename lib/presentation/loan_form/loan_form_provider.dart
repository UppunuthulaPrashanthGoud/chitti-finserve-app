import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/loan_form_repository.dart';
import '../../data/model/loan_form_model.dart';

final loanFormRepositoryProvider = Provider<LoanFormRepository>((ref) {
  return LoanFormRepository();
});

final loanFormConfigProvider = FutureProvider.autoDispose<LoanFormModel>((ref) async {
  final repo = ref.read(loanFormRepositoryProvider);
  return repo.fetchLoanFormConfig();
});

final loanFormStateProvider = StateNotifierProvider<LoanFormNotifier, LoanFormState>((ref) {
  final repository = ref.read(loanFormRepositoryProvider);
  return LoanFormNotifier(repository);
});

final userApplicationsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  final repo = ref.read(loanFormRepositoryProvider);
  return repo.getUserApplications(userId);
});

final applicationByIdProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, applicationId) async {
  final repo = ref.read(loanFormRepositoryProvider);
  return repo.getApplicationById(applicationId);
});

class LoanFormState {
  final bool isLoading;
  final String? error;
  final bool isSubmitted;
  final Map<String, dynamic>? submittedData;

  LoanFormState({
    this.isLoading = false,
    this.error,
    this.isSubmitted = false,
    this.submittedData,
  });

  LoanFormState copyWith({
    bool? isLoading,
    String? error,
    bool? isSubmitted,
    Map<String, dynamic>? submittedData,
  }) {
    return LoanFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      submittedData: submittedData ?? this.submittedData,
    );
  }
}

class LoanFormNotifier extends StateNotifier<LoanFormState> {
  final LoanFormRepository _repository;

  LoanFormNotifier(this._repository) : super(LoanFormState());

  Future<void> submitApplication(Map<String, dynamic> formData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _repository.submitLoanApplication(formData);
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        submittedData: result['data'],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetState() {
    state = LoanFormState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
