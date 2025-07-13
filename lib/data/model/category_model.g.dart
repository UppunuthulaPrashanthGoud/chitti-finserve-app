// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'description': instance.description,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
