// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  (json['orderStatus'] as String).getOrderStatusFromString(),
  from: AddressModel.fromJson(json['from'] as Map<String, dynamic>),
  to: AddressModel.fromJson(json['to'] as Map<String, dynamic>),
  distance: (json['distance'] as num).toDouble(),
  employerId: json['employerId'] as String,
  driverId: json['driverId'] as String?,
  startTime: DateTime.parse(json['startTime'] as String).toLocal(),
  orderForAnother: json['orderForAnother'] != null ? OrderForAnother.fromJson(json['orderForAnother']) : null, costInRub: json['costInRub'],
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'orderStatus': instance.status.toString(),
  'from': instance.from,
  'to': instance.to,
  'employerId': instance.employerId,
  'driverId': instance.driverId,
  'distance': instance.distance,
  'startTime': instance.startTime.toUtc().toIso8601String(),
  'orderForAnother': instance.orderForAnother?.toJson(),
  'costInRub': instance.costInRub
};
