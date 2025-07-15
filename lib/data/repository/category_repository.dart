import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/network_service.dart';
import '../model/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await NetworkService.get('/categories');
      final jsonMap = NetworkService.parseResponse(response);
      final categories = jsonMap['data'] as List<dynamic>;
      
      print('API Response - Categories count: ${categories.length}');
      if (categories.isNotEmpty) {
        print('Using API categories');
        return categories.map((e) => CategoryModel.fromJson(e)).toList();
      }
      
      print('API returned empty, using local fallback');
      return await _loadLocalCategories();
    } catch (e) {
      print('API failed, using local fallback: $e');
      return await _loadLocalCategories();
    }
  }

  Future<List<CategoryModel>> _loadLocalCategories() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/categories.json');
      final jsonMap = json.decode(jsonString);
      final categories = jsonMap['categories'] as List<dynamic>;
      
      return categories.map((e) => CategoryModel.fromJson({
        '_id': e['id'],
        'name': e['name'],
        'icon': e['icon'],
        'description': '',
        'isActive': true,
        'sortOrder': 0,
      })).toList();
    } catch (e) {
      throw Exception('Failed to load local categories: $e');
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
