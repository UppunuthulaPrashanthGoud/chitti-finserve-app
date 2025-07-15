import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class ContactModel {
  final String? companyName;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? address;
  final String? workingHours;
  final String? website;
  final Map<String, dynamic>? socialMedia;
  final bool? isActive;

  ContactModel({
    this.companyName,
    this.email,
    this.phone,
    this.whatsapp,
    this.address,
    this.workingHours,
    this.website,
    this.socialMedia,
    this.isActive,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
