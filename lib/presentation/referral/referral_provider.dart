import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/referral_repository.dart';
import '../../data/model/referral_model.dart';

final referralRepositoryProvider = Provider<ReferralRepository>((ref) {
  return ReferralRepository();
});

// Referral data provider with caching
final referralDataProvider = FutureProvider<ReferralDataModel>((ref) async {
  final repo = ref.read(referralRepositoryProvider);
  print('🔄 ReferralDataProvider: Fetching referral data');
  return repo.getMyReferrals();
});

// Wallet transactions provider with caching
final walletTransactionsProvider = FutureProvider.family<WalletTransactionsResponseModel, String>((ref, key) async {
  final repo = ref.read(referralRepositoryProvider);
  // Parse page and limit from key (format: "page_limit")
  final parts = key.split('_');
  final page = int.tryParse(parts[0]) ?? 1;
  final limit = int.tryParse(parts[1]) ?? 10;
  
  print('🔄 WalletTransactionsProvider: Fetching page $page, limit $limit');
  
  return repo.getWalletTransactions(
    page: page,
    limit: limit,
  );
});

// Share referral data provider
final shareReferralDataProvider = FutureProvider<ShareReferralModel>((ref) async {
  final repo = ref.read(referralRepositoryProvider);
  print('🔄 ShareReferralDataProvider: Fetching share data');
  return repo.getShareReferralData();
});

// Referral code verification provider
final referralCodeVerificationProvider = StateNotifierProvider<ReferralCodeVerificationNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ReferralCodeVerificationNotifier(ref.read(referralRepositoryProvider));
});

class ReferralCodeVerificationNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ReferralRepository _repository;

  ReferralCodeVerificationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> verifyReferralCode(String referralCode) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.verifyReferralCode(referralCode);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// Referral code application provider
final referralCodeApplicationProvider = StateNotifierProvider<ReferralCodeApplicationNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ReferralCodeApplicationNotifier(ref.read(referralRepositoryProvider));
});

class ReferralCodeApplicationNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ReferralRepository _repository;

  ReferralCodeApplicationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> applyReferralCode(String referralCode) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.applyReferralCode(referralCode);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// Withdrawal request provider
final withdrawalRequestProvider = StateNotifierProvider<WithdrawalRequestNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return WithdrawalRequestNotifier(ref.read(referralRepositoryProvider));
});

class WithdrawalRequestNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ReferralRepository _repository;

  WithdrawalRequestNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> requestWithdrawal({
    required double amount,
    required String bankDetails,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.requestWithdrawal(
        amount: amount,
        bankDetails: bankDetails,
      );
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
} 
 
 