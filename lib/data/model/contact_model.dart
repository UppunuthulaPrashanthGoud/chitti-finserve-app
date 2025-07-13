import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class ContactModel {
  final String? officeAddress;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? hours;
  final String? workingHours;
  final String? address;
  final String? website;
  final Map<String, dynamic>? socialMedia;
  final bool? isActive;

  ContactModel({
    this.officeAddress,
    this.phone,
    this.whatsapp,
    this.email,
    this.hours,
    this.workingHours,
    this.address,
    this.website,
    this.socialMedia,
    this.isActive,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
