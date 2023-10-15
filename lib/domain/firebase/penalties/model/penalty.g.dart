// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penalty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Penalty _$PenaltyFromJson(Map<String, dynamic> json) => Penalty(
      dateTime: DateTime.parse(json['dateTime'] as String),
      userId: json['userId'] as String,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$PenaltyToJson(Penalty instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'userId': instance.userId,
      'cost': instance.cost,
    };
