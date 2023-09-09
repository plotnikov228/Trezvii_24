// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      driverId: json['driverId'] as String,
      employerId: json['employerId'] as String,
    )..id = json['id'] as String?;

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'employerId': instance.employerId,
    };
