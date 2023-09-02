import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'personal_data_of_the_driver.g.dart';

@JsonSerializable()
class PersonalDataOfTheDriver {
  final String name;
  final String birthDate;
  final bool male;
  final String address;
  final String number;

  final String passPhotoUrl;
  final String registrationPhotoUrl;
  final String driverLicenseFrontPhotoUrl;
  final String driverLicenseBackPhotoUrl;
  final String driverPhotoUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? passPhoto;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? registrationPhoto;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? driverLicenseFrontPhoto;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? driverLicenseBackPhoto;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? driverPhoto;

  PersonalDataOfTheDriver({
    this.passPhoto,
    this.registrationPhoto,
    this.driverLicenseFrontPhoto,
    this.driverLicenseBackPhoto,
    this.driverPhoto,
    required this.name,
    required this.birthDate,
    required this.male,
    required this.address,
    required this.number,
    required this.passPhotoUrl,
    required this.registrationPhotoUrl,
    required this.driverLicenseFrontPhotoUrl,
    required this.driverLicenseBackPhotoUrl,
    required this.driverPhotoUrl,
  });

  factory PersonalDataOfTheDriver.fromJson(Map<String, dynamic> json) =>
      _$PersonalDataOfTheDriverFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalDataOfTheDriverToJson(this);

  PersonalDataOfTheDriver fillUrls(
      {required String passPhotoUrl,
      required String registrationPhotoUrl,
      required String driverLicenceFrontUrl,
      required String driverLicenseBackUrl,
      required String driverPhotoUrl}) {
    return PersonalDataOfTheDriver(
        name: name,
        birthDate: birthDate,
        male: male,
        address: address,
        number: number,
        passPhotoUrl: passPhotoUrl,
        registrationPhotoUrl: registrationPhotoUrl,
        driverLicenseFrontPhotoUrl: driverLicenceFrontUrl,
        driverLicenseBackPhotoUrl: driverLicenseBackUrl,
        driverPhotoUrl: driverPhotoUrl);
  }
}
