import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String? bannerImage;
  final String? welcomeTitle;
  final String? welcomeSubtitle;
  final bool? enableOTP;
  final bool? enableRegistration;
  final bool? enableForgotPassword;
  final bool? enableBiometric;
  final String? termsText;

  // Legacy fields for backward compatibility
  final String? title;
  final String? mobileLabel;
  final String? otpLabel;
  final String? getOtpButton;
  final String? verifyOtpButton;
  final bool? autoLogin;
  final int? otpLength;
  final String? successMessage;
  final String? errorMessage;

  LoginModel({
    this.bannerImage,
    this.welcomeTitle,
    this.welcomeSubtitle,
    this.enableOTP,
    this.enableRegistration,
    this.enableForgotPassword,
    this.enableBiometric,
    this.termsText,
    // Legacy fields
    this.title,
    this.mobileLabel,
    this.otpLabel,
    this.getOtpButton,
    this.verifyOtpButton,
    this.autoLogin,
    this.otpLength,
    this.successMessage,
    this.errorMessage,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
