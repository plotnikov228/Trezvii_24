// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      bonuses: json['bonuses'] as int,
      userId: json['userId'] as String,
      number: json['number'] as String,
      ratings: (json['ratings'] as List<dynamic>).map((e) => double.parse(e.toString())).toList()
          .map((e) => (e as num).toDouble())
          .toList(),
      email: json['email'] as String,
      blocked: (json['blocked'] as dynamic) ?? false,
      name: json['name'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ratings': instance.ratings,
      'userId': instance.userId,
      'number': instance.number,
      'blocked': instance.blocked,
      'email': instance.email,
      'name': instance.name,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'bonuses': instance.bonuses,
    };
