// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      name: json['name'] as String?,
      locality: json['locality'] as String?,
      comment: json['comment'] as String?,
      addressName: json['addressName'] as String,
      entrance: json['entrance'] as String?,
      appLatLong:
          AppLatLong.fromJson(json['appLatLong'] as Map<String, dynamic>),
      province: json['province'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'addressName': instance.addressName,
      'appLatLong': instance.appLatLong.toJson(),
      'name': instance.name,
      'entrance': instance.entrance,
      'comment': instance.comment,
      'locality': instance.locality,
      'province': instance.province,
    };
