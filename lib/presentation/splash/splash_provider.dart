import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/splash_repository.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepository();
});

final splashContentProvider = FutureProvider.autoDispose<SplashContent>((ref) async {
  final repo = ref.read(splashRepositoryProvider);
  return repo.fetchSplashContent();
});
