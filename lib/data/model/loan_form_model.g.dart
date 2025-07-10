// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanFormField _$LoanFormFieldFromJson(Map<String, dynamic> json) =>
    LoanFormField(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      autofill: json['autofill'] as bool?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LoanFormFieldToJson(LoanFormField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'required': instance.required,
      'autofill': instance.autofill,
      'options': instance.options,
    };

LoanFormModel _$LoanFormModelFromJson(Map<String, dynamic> json) =>
    LoanFormModel(
      title: json['title'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => LoanFormField.fromJson(e as Map<String, dynamic>))
          .toList(),
      submitButton: json['submitButton'] as String,
      thankYouMessage: json['thankYouMessage'] as String,
      errorMessage: json['errorMessage'] as String,
    );

Map<String, dynamic> _$LoanFormModelToJson(LoanFormModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'fields': instance.fields,
      'submitButton': instance.submitButton,
      'thankYouMessage': instance.thankYouMessage,
      'errorMessage': instance.errorMessage,
    };
