// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanFormField _$LoanFormFieldFromJson(Map<String, dynamic> json) =>
    LoanFormField(
      id: json['id'] as String?,
      label: json['label'] as String?,
      type: json['type'] as String?,
      required: json['required'] as bool?,
      autofill: json['autofill'] as bool?,
      options: json['options'] as List<dynamic>?,
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
      title: json['title'] as String?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => LoanFormField.fromJson(e as Map<String, dynamic>))
          .toList(),
      submitButton: json['submitButton'] as String?,
      thankYouMessage: json['thankYouMessage'] as String?,
      errorMessage: json['errorMessage'] as String?,
      formTitle: json['formTitle'] as String?,
      formSubtitle: json['formSubtitle'] as String?,
      enableDocuments: json['enableDocuments'] as bool?,
      enableTerms: json['enableTerms'] as bool?,
      requiredFields: (json['requiredFields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      categories: json['categories'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$LoanFormModelToJson(LoanFormModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'fields': instance.fields,
      'submitButton': instance.submitButton,
      'thankYouMessage': instance.thankYouMessage,
      'errorMessage': instance.errorMessage,
      'formTitle': instance.formTitle,
      'formSubtitle': instance.formSubtitle,
      'enableDocuments': instance.enableDocuments,
      'enableTerms': instance.enableTerms,
      'requiredFields': instance.requiredFields,
      'categories': instance.categories,
      'isActive': instance.isActive,
    };
