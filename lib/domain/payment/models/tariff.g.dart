// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tariff _$TariffFromJson(Map<String, dynamic> json) => Tariff(
      name: json['name'] as String,
      description: json['description'],
      checkOutCity: json['checkOutCity'] as bool,
      displayCost: json['displayCost'] as String,
      theCostOfFirstHoursKey: json['theCostOfFirstHoursKey'] as String?,
      kmPriceKey: json['kmPriceKey'] as String?,
      startPriceKey: json['startPriceKey'] as String?,
      hourPriceKey: json['hourPriceKey'] as String?,
      hoursCount: json['hoursCount'] as int?,
      kmPriceInVillageKey: json['kmPriceInVillageKey'] as String?,
    );

Map<String, dynamic> _$TariffToJson(Tariff instance) => <String, dynamic>{
      'name': instance.name,
      'displayCost': instance.displayCost,
      'startPriceKey': instance.startPriceKey,
      'checkOutCity': instance.checkOutCity,
      'theCostOfFirstHoursKey': instance.theCostOfFirstHoursKey,
      'kmPriceKey': instance.kmPriceKey,
      'hourPriceKey': instance.hourPriceKey,
      'hoursCount': instance.hoursCount,
      'kmPriceInVillageKey': instance.kmPriceInVillageKey,
      'description': instance.description
    };
