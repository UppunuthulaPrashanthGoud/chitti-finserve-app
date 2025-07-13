import 'package:json_annotation/json_annotation.dart';

part 'loan_form_model.g.dart';

@JsonSerializable()
class LoanFormField {
  final String? id;
  final String? label;
  final String? type;
  final bool? required;
  final bool? autofill;
  final List<dynamic>? options; // Can be List<String> or List<Map<String, dynamic>>

  LoanFormField({
    this.id,
    this.label,
    this.type,
    this.required,
    this.autofill,
    this.options,
  });

  factory LoanFormField.fromJson(Map<String, dynamic> json) => _$LoanFormFieldFromJson(json);
  Map<String, dynamic> toJson() => _$LoanFormFieldToJson(this);
}

@JsonSerializable()
class LoanFormModel {
  final String? title;
  final List<LoanFormField>? fields;
  final String? submitButton;
  final String? thankYouMessage;
  final String? errorMessage;
  final String? formTitle;
  final String? formSubtitle;
  final bool? enableDocuments;
  final bool? enableTerms;
  final List<String>? requiredFields;
  final String? categories;
  final bool? isActive;

  LoanFormModel({
    this.title,
    this.fields,
    this.submitButton,
    this.thankYouMessage,
    this.errorMessage,
    this.formTitle,
    this.formSubtitle,
    this.enableDocuments,
    this.enableTerms,
    this.requiredFields,
    this.categories,
    this.isActive,
  });

  factory LoanFormModel.fromJson(Map<String, dynamic> json) => _$LoanFormModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoanFormModelToJson(this);
}
