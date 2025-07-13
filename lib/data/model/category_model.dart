import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? icon;
  final String? description;
  final bool? isActive;
  final int? sortOrder;
  final dynamic createdBy; // Changed to dynamic to handle populated object
  final dynamic updatedBy; // Changed to dynamic to handle populated object
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    this.isActive,
    this.sortOrder,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Getter for creator name
  String? get creatorName {
    if (createdBy is Map<String, dynamic>) {
      return createdBy['name'] as String?;
    }
    return null;
  }

  // Getter for updater name
  String? get updaterName {
    if (updatedBy is Map<String, dynamic>) {
      return updatedBy['name'] as String?;
    }
    return null;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
