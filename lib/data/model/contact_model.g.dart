// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      officeAddress: json['officeAddress'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      hours: json['hours'] as String?,
      workingHours: json['workingHours'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      socialMedia: json['socialMedia'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'officeAddress': instance.officeAddress,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'hours': instance.hours,
      'workingHours': instance.workingHours,
      'address': instance.address,
      'website': instance.website,
      'socialMedia': instance.socialMedia,
      'isActive': instance.isActive,
    };
