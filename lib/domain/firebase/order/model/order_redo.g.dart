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
  paymentMethod: PaymentMethod.fromString((json['paymentMethod'] as dynamic) ?? CashPaymentMethod().toString()),
  wishes: json['wishes'],
  cancelReason: json['cancelReason'],
  isPaid: (json['isPaid'] as dynamic)?? false,
  driverId: json['driverId'] as String?,
  startTime: json['startTime'] is String ? DateTime.parse(json['startTime'] as String) : (json['startTime'] as Timestamp).toDate(),
  orderForAnother: json['orderForAnother'] != null ? OrderForAnother.fromJson(json['orderForAnother']) : null, costInRub: double.parse(json['costInRub'].toString()),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'orderStatus': instance.status.toString(),
  'from': instance.from.toJson(),
  'wishes': instance.wishes,
  'isPaid': instance.isPaid,
  'paymentMethod': instance.paymentMethod.toString(),
  'to': instance.to.toJson(),
  'employerId': instance.employerId,
  'driverId': instance.driverId,
  'cancelReason': instance.cancelReason,
  'distance': instance.distance,
  'startTime': instance.startTime,
  'orderForAnother': instance.orderForAnother?.toJson(),
  'costInRub': instance.costInRub
};
