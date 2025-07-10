import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/lead_status_repository.dart';

final leadStatusRepositoryProvider = Provider<LeadStatusRepository>((ref) {
  return LeadStatusRepository();
});

final leadStatusesProvider = FutureProvider.autoDispose<List<LeadStatus>>((ref) async {
  final repo = ref.read(leadStatusRepositoryProvider);
  return repo.fetchLeadStatuses();
});

final leadStatusByIdProvider = FutureProvider.family<LeadStatus, String>((ref, id) async {
  final repo = ref.read(leadStatusRepositoryProvider);
  return repo.getLeadStatusById(id);
}); 