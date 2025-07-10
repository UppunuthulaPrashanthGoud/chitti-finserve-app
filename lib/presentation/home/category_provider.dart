import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/category_repository.dart';
import '../../data/model/category_model.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoryListProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.fetchCategories();
});

final categoryByIdProvider = FutureProvider.family<CategoryModel, String>((ref, id) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.getCategoryById(id);
});
