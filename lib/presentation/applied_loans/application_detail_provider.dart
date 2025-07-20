import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/loan_form_repository.dart';

class ApplicationDetailNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final LoanFormRepository _repository;

  ApplicationDetailNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchApplicationDetails(String applicationId) async {
    try {
      print('🔧 Debug: fetchApplicationDetails called with ID: $applicationId');
      state = const AsyncValue.loading();
      
      print('🔧 Debug: Making API call to get application details...');
      final response = await _repository.getApplicationById(applicationId);
      print('🔧 Debug: API response received: ${response.toString()}');
      
      if (response['success'] == true && response['data'] != null) {
        print('🔧 Debug: Application details fetched successfully');
        state = AsyncValue.data(response['data']);
      } else {
        print('🔧 Debug: API response indicates failure');
        state = AsyncValue.error(
          response['message'] ?? 'Failed to fetch application details',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      print('🔧 Debug: Error in fetchApplicationDetails: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearApplicationDetails() {
    state = const AsyncValue.data(null);
  }

  void refreshApplicationDetails(String applicationId) {
    fetchApplicationDetails(applicationId);
  }
}

final applicationDetailProvider = StateNotifierProvider<ApplicationDetailNotifier, AsyncValue<Map<String, dynamic>?>>(
  (ref) => ApplicationDetailNotifier(
    ref.read(loanFormRepositoryProvider),
  ),
);

// Provider for loan form repository
final loanFormRepositoryProvider = Provider<LoanFormRepository>(
  (ref) => LoanFormRepository(),
); 