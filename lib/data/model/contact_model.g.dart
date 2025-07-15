// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      companyName: json['companyName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      address: json['address'] as String?,
      workingHours: json['workingHours'] as String?,
      website: json['website'] as String?,
      socialMedia: json['socialMedia'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'email': instance.email,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'address': instance.address,
      'workingHours': instance.workingHours,
      'website': instance.website,
      'socialMedia': instance.socialMedia,
      'isActive': instance.isActive,
    };
