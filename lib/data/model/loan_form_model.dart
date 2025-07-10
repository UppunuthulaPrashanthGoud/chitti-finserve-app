import 'package:json_annotation/json_annotation.dart';

part 'loan_form_model.g.dart';

@JsonSerializable()
class LoanFormField {
  final String id;
  final String label;
  final String type;
  final bool required;
  final bool? autofill;
  final List<String>? options;

  LoanFormField({
    required this.id,
    required this.label,
    required this.type,
    required this.required,
    this.autofill,
    this.options,
  });

  factory LoanFormField.fromJson(Map<String, dynamic> json) => _$LoanFormFieldFromJson(json);
  Map<String, dynamic> toJson() => _$LoanFormFieldToJson(this);
}

@JsonSerializable()
class LoanFormModel {
  final String title;
  final List<LoanFormField> fields;
  final String submitButton;
  final String thankYouMessage;
  final String errorMessage;

  LoanFormModel({
    required this.title,
    required this.fields,
    required this.submitButton,
    required this.thankYouMessage,
    required this.errorMessage,
  });

  factory LoanFormModel.fromJson(Map<String, dynamic> json) => _$LoanFormModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoanFormModelToJson(this);
}
