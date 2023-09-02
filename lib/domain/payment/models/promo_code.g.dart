// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoCode _$PromoCodeFromJson(Map<String, dynamic> json) => PromoCode(
      json['promo'] as String,
      (json['discount'] as num).toDouble(),
      (json['activatedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PromoCodeToJson(PromoCode instance) => <String, dynamic>{
      'promo': instance.promo,
      'discount': instance.discount,
      'activatedUsers': instance.activatedUsers,
    };
