import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/contact_repository.dart';
import '../../data/model/contact_model.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository();
});

final contactProvider = FutureProvider.autoDispose<ContactModel>((ref) async {
  final repo = ref.read(contactRepositoryProvider);
  return repo.fetchContact();
});

final contactFormStateProvider = StateNotifierProvider<ContactFormNotifier, ContactFormState>((ref) {
  final repository = ref.read(contactRepositoryProvider);
  return ContactFormNotifier(repository);
});

class ContactFormState {
  final bool isLoading;
  final String? error;
  final bool isSubmitted;

  ContactFormState({
    this.isLoading = false,
    this.error,
    this.isSubmitted = false,
  });

  ContactFormState copyWith({
    bool? isLoading,
    String? error,
    bool? isSubmitted,
  }) {
    return ContactFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

class ContactFormNotifier extends StateNotifier<ContactFormState> {
  final ContactRepository _repository;

  ContactFormNotifier(this._repository) : super(ContactFormState());

  Future<void> submitContactForm(Map<String, dynamic> formData) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.submitContactForm(formData);
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetState() {
    state = ContactFormState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
