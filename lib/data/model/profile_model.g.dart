// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      fullName: json['fullName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      emailId: json['emailId'] as String?,
      loanAmount: json['loanAmount'] as String?,
      purposeOfLoan: json['purposeOfLoan'] as String?,
      monthlyIncome: json['monthlyIncome'] as String?,
      occupation: json['occupation'] as String?,
      profilePicture: json['profilePicture'] as String?,
      aadharUpload: json['aadharUpload'] as String?,
      panUpload: json['panUpload'] as String?,
      aadharNumber: json['aadharNumber'] as String?,
      panNumber: json['panNumber'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'mobileNumber': instance.mobileNumber,
      'emailId': instance.emailId,
      'loanAmount': instance.loanAmount,
      'purposeOfLoan': instance.purposeOfLoan,
      'monthlyIncome': instance.monthlyIncome,
      'occupation': instance.occupation,
      'profilePicture': instance.profilePicture,
      'aadharUpload': instance.aadharUpload,
      'panUpload': instance.panUpload,
      'aadharNumber': instance.aadharNumber,
      'panNumber': instance.panNumber,
    };
