// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      name: json['name'] as String?,
      addressName: json['addressName'] as String,
      appLatLong:
          AppLatLong.fromJson(json['appLatLong'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'addressName': instance.addressName,
      'appLatLong': instance.appLatLong.toJson(),
      'name': instance.name,
    };
