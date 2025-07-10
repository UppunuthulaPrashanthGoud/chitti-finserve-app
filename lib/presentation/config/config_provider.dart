import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/config_repository.dart';

final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepository();
});

final appConfigProvider = FutureProvider.autoDispose<AppConfig>((ref) async {
  final repo = ref.read(configRepositoryProvider);
  return repo.fetchAppConfig();
});

final legalPagesProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.read(configRepositoryProvider);
  return repo.getLegalPages();
});

final notificationSettingsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repo = ref.read(configRepositoryProvider);
  return repo.getNotificationSettings();
}); 