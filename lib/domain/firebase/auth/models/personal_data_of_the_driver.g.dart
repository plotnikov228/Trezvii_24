// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_of_the_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDataOfTheDriver _$PersonalDataOfTheDriverFromJson(
        Map<String, dynamic> json) =>
    PersonalDataOfTheDriver(
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      male: json['male'] as bool,
      address: json['address'] as String,
      number: json['number'] as String,
      passPhotoUrl: json['passPhotoUrl'] as String,
      registrationPhotoUrl: json['registrationPhotoUrl'] as String,
      driverLicenseFrontPhotoUrl: json['driverLicenseFrontPhotoUrl'] as String,
      driverLicenseBackPhotoUrl: json['driverLicenseBackPhotoUrl'] as String,
      driverPhotoUrl: json['driverPhotoUrl'] as String,
    );

Map<String, dynamic> _$PersonalDataOfTheDriverToJson(
        PersonalDataOfTheDriver instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthDate': instance.birthDate,
      'male': instance.male,
      'address': instance.address,
      'number': instance.number,
      'passPhotoUrl': instance.passPhotoUrl,
      'registrationPhotoUrl': instance.registrationPhotoUrl,
      'driverLicenseFrontPhotoUrl': instance.driverLicenseFrontPhotoUrl,
      'driverLicenseBackPhotoUrl': instance.driverLicenseBackPhotoUrl,
      'driverPhotoUrl': instance.driverPhotoUrl,
    };
