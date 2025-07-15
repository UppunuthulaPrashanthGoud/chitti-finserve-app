import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String? description;
  final String image;
  final String? link;
  final int sortOrder;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    required this.id,
    required this.title,
    this.description,
    required this.image,
    this.link,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class BannerListModel {
  final List<BannerModel> data;
  final Map<String, dynamic>? pagination;

  BannerListModel({required this.data, this.pagination});

  factory BannerListModel.fromJson(Map<String, dynamic> json) => _$BannerListModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerListModelToJson(this);
} 