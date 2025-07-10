import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String title;
  final String mobileLabel;
  final String otpLabel;
  final String getOtpButton;
  final String verifyOtpButton;
  final bool autoLogin;
  final int otpLength;
  final String successMessage;
  final String errorMessage;

  LoginModel({
    required this.title,
    required this.mobileLabel,
    required this.otpLabel,
    required this.getOtpButton,
    required this.verifyOtpButton,
    required this.autoLogin,
    required this.otpLength,
    required this.successMessage,
    required this.errorMessage,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
