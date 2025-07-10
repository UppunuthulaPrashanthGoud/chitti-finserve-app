import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String color;
  final String action;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
    required this.action,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class BannerListModel {
  final List<BannerModel> banners;

  BannerListModel({required this.banners});

  factory BannerListModel.fromJson(Map<String, dynamic> json) => _$BannerListModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerListModelToJson(this);
} 