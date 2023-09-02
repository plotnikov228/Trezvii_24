// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      color: json['color'] as String,
      model: json['model'] as String,
      number: json['number'] as String,
      brand: json['brand'] as String,
      releaseDate: json['releaseDate'] as String,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'color': instance.color,
      'model': instance.model,
      'number': instance.number,
      'brand': instance.brand,
      'releaseDate': instance.releaseDate,
    };
