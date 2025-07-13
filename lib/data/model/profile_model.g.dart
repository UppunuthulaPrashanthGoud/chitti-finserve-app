// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profilePicture: json['profilePicture'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      aadharUpload: json['aadharUpload'] as String?,
      panNumber: json['panNumber'] as String?,
      panUpload: json['panUpload'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'profilePicture': instance.profilePicture,
      'aadharNumber': instance.aadharNumber,
      'aadharUpload': instance.aadharUpload,
      'panNumber': instance.panNumber,
      'panUpload': instance.panUpload,
    };
