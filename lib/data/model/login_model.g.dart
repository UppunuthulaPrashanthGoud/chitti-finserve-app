// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      bannerImage: json['bannerImage'] as String?,
      welcomeTitle: json['welcomeTitle'] as String?,
      welcomeSubtitle: json['welcomeSubtitle'] as String?,
      enableOTP: json['enableOTP'] as bool?,
      enableRegistration: json['enableRegistration'] as bool?,
      enableForgotPassword: json['enableForgotPassword'] as bool?,
      enableBiometric: json['enableBiometric'] as bool?,
      termsText: json['termsText'] as String?,
      title: json['title'] as String?,
      mobileLabel: json['mobileLabel'] as String?,
      otpLabel: json['otpLabel'] as String?,
      getOtpButton: json['getOtpButton'] as String?,
      verifyOtpButton: json['verifyOtpButton'] as String?,
      autoLogin: json['autoLogin'] as bool?,
      otpLength: (json['otpLength'] as num?)?.toInt(),
      successMessage: json['successMessage'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'bannerImage': instance.bannerImage,
      'welcomeTitle': instance.welcomeTitle,
      'welcomeSubtitle': instance.welcomeSubtitle,
      'enableOTP': instance.enableOTP,
      'enableRegistration': instance.enableRegistration,
      'enableForgotPassword': instance.enableForgotPassword,
      'enableBiometric': instance.enableBiometric,
      'termsText': instance.termsText,
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
