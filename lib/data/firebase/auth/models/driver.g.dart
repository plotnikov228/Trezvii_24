// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      confirmed: json['confirmed'] as bool,
      currentPosition: json['currentPosition'] == null
          ? null
          : AppLatLong.fromJson(
              json['currentPosition'] as Map<String, dynamic>),
      ratings: (json['ratings'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      userId: json['userId'] as String,
      blocked: json['blocked'] as bool? ?? false,
      number: json['number'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      personalDataOfTheDriver: json['personalDataOfTheDriver'] == null
          ? null
          : PersonalDataOfTheDriver.fromJson(
              json['personalDataOfTheDriver'] as Map<String, dynamic>),
      car: json['car'] == null
          ? null
          : Car.fromJson(json['car'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'userId': instance.userId,
      'number': instance.number,
      'email': instance.email,
      'name': instance.name,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'ratings': instance.ratings,
      'blocked': instance.blocked,
      'currentPosition': instance.currentPosition,
      'confirmed': instance.confirmed,
      'personalDataOfTheDriver': instance.personalDataOfTheDriver,
      'car': instance.car,
    };
