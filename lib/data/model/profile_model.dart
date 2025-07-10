import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String fullName;
  final String mobileNumber;
  final String? emailId;
  final String? loanAmount;
  final String? purposeOfLoan;
  final String? monthlyIncome;
  final String? occupation;
  final String? profilePicture;
  final String? aadharUpload;
  final String? panUpload;
  final String? aadharNumber;
  final String? panNumber;

  ProfileModel({
    required this.fullName,
    required this.mobileNumber,
    this.emailId,
    this.loanAmount,
    this.purposeOfLoan,
    this.monthlyIncome,
    this.occupation,
    this.profilePicture,
    this.aadharUpload,
    this.panUpload,
    this.aadharNumber,
    this.panNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? fullName,
    String? mobileNumber,
    String? emailId,
    String? loanAmount,
    String? purposeOfLoan,
    String? monthlyIncome,
    String? occupation,
    String? profilePicture,
    String? aadharUpload,
    String? panUpload,
    String? aadharNumber,
    String? panNumber,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      loanAmount: loanAmount ?? this.loanAmount,
      purposeOfLoan: purposeOfLoan ?? this.purposeOfLoan,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      occupation: occupation ?? this.occupation,
      profilePicture: profilePicture ?? this.profilePicture,
      aadharUpload: aadharUpload ?? this.aadharUpload,
      panUpload: panUpload ?? this.panUpload,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      panNumber: panNumber ?? this.panNumber,
    );
  }
} 