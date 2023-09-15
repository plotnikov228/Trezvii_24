// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCard _$UserCardFromJson(Map<String, dynamic> json) => UserCard(
      number: json['number'] as String,
      monthAndYear: json['monthAndYear'] as String,
      cvvOrCvc: json['cvvOrCvc'] as String,
      email: json['notification'] as String?,
    );

Map<String, dynamic> _$UserCardToJson(UserCard instance) => <String, dynamic>{
      'number': instance.number,
      'monthAndYear': instance.monthAndYear,
      'cvvOrCvc': instance.cvvOrCvc,
      'notification': instance.email,
    };
