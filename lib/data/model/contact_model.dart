import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class ContactModel {
  final String officeAddress;
  final String phone;
  final String whatsapp;
  final String email;
  final String hours;

  ContactModel({required this.officeAddress, required this.phone, required this.whatsapp, required this.email, required this.hours});

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
