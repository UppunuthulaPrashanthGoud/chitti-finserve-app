// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      title: json['title'] as String,
      mobileLabel: json['mobileLabel'] as String,
      otpLabel: json['otpLabel'] as String,
      getOtpButton: json['getOtpButton'] as String,
      verifyOtpButton: json['verifyOtpButton'] as String,
      autoLogin: json['autoLogin'] as bool,
      otpLength: (json['otpLength'] as num).toInt(),
      successMessage: json['successMessage'] as String,
      errorMessage: json['errorMessage'] as String,
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'mobileLabel': instance.mobileLabel,
      'otpLabel': instance.otpLabel,
      'getOtpButton': instance.getOtpButton,
      'verifyOtpButton': instance.verifyOtpButton,
      'autoLogin': instance.autoLogin,
      'otpLength': instance.otpLength,
      'successMessage': instance.successMessage,
      'errorMessage': instance.errorMessage,
    };
