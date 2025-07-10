// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      officeAddress: json['officeAddress'] as String,
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
      email: json['email'] as String,
      hours: json['hours'] as String,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'officeAddress': instance.officeAddress,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'hours': instance.hours,
    };
