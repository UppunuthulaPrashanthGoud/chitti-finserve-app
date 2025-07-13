import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePicture;
  final String? aadharNumber;
  final String? aadharUpload;
  final String? panNumber;
  final String? panUpload;

  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
    this.aadharNumber,
    this.aadharUpload,
    this.panNumber,
    this.panUpload,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
    String? aadharNumber,
    String? aadharUpload,
    String? panNumber,
    String? panUpload,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      aadharUpload: aadharUpload ?? this.aadharUpload,
      panNumber: panNumber ?? this.panNumber,
      panUpload: panUpload ?? this.panUpload,
    );
  }
} 