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
  wishes: json['wishes'],
  cancelReason: json['cancelReason'],
  driverId: json['driverId'] as String?,
  startTime: DateTime.parse(json['startTime'] as String),
  orderForAnother: json['orderForAnother'] != null ? OrderForAnother.fromJson(json['orderForAnother']) : null, costInRub: double.parse(json['costInRub'].toString()),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'orderStatus': instance.status.toString(),
  'from': instance.from.toJson(),
  'wishes': instance.wishes,
  'to': instance.to.toJson(),
  'employerId': instance.employerId,
  'driverId': instance.driverId,
  'cancelReason': instance.cancelReason,
  'distance': instance.distance,
  'startTime': instance.startTime.toIso8601String(),
  'orderForAnother': instance.orderForAnother?.toJson(),
  'costInRub': instance.costInRub
};
