import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/extensions/string_extension.dart';
import 'order_for_another.dart';
import 'order_status.dart';

part 'order_redo.g.dart';

class Order {
  final AddressModel from;
  final AddressModel to;
  final String employerId;
  final String? driverId;
  final double distance;
  final DateTime startTime;
  final OrderStatus status;
  final OrderForAnother? orderForAnother;
  final double costInRub;
  final String? wishes;

  Order(this.status,
      {
        this.orderForAnother,required this.costInRub,
      required this.from,
      required this.to,
      required this.distance,
      required this.employerId, this.driverId,
      required this.startTime,
        this.wishes,});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
