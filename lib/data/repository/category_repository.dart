import 'dart:convert';
import '../../core/network_service.dart';
import '../model/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await NetworkService.get('/categories');
      final jsonMap = NetworkService.parseResponse(response);
      final categories = jsonMap['data'] as List<dynamic>;
      return categories.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final response = await NetworkService.get('/categories/$id');
      final jsonMap = NetworkService.parseResponse(response);
      return CategoryModel.fromJson(jsonMap['data']);
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}
