// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      bonuses: json['bonuses'] as int,
      userId: json['userId'] as String,
      number: json['number'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      ratings: json['ratings'] ?? <double>[],
      registrationDate: DateTime.parse(json['registrationDate'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'number': instance.number,
      'email': instance.email,
      'name': instance.name,
      'ratings': instance.ratings ,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'bonuses': instance.bonuses,
    };
