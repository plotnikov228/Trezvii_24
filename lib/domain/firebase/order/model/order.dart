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
  final String? cancelReason;

  Order(this.status,
      {
        this.orderForAnother,required this.costInRub, this.cancelReason,
      required this.from,
      required this.to,
      required this.distance,
      required this.employerId, this.driverId,
      required this.startTime,
        this.wishes,});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith({
    AddressModel? from,
    AddressModel? to,
    String? employerId,
    String? cancelReason,
    String? driverId,
    double? distance,
    DateTime? startTime,
    OrderStatus? status,
    OrderForAnother? orderForAnother,
    double? costInRub,
    String? wishes,
  }) {
    return Order(
      status ?? this.status,
      orderForAnother: orderForAnother ?? this.orderForAnother,
      costInRub: costInRub ?? this.costInRub,
      from: from ?? this.from,
      to: to ?? this.to,
      cancelReason: cancelReason ?? this.cancelReason,
      distance: distance ?? this.distance,
      employerId: employerId ?? this.employerId,
      driverId: driverId ?? this.driverId,
      startTime: startTime ?? this.startTime,
      wishes: wishes ?? this.wishes,
    );
  }

  bool isActive () {
    return status.toString() != OrderCancelledByDriverOrderStatus().toString() &&
        status.toString() != CancelledOrderStatus().toString() &&
        status.toString() != SuccessfullyCompletedOrderStatus().toString();

  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Order &&
              runtimeType == other.runtimeType &&
              from == other.from &&
              to == other.to &&
              employerId == other.employerId &&
              driverId == other.driverId &&
              distance == other.distance &&
              startTime == other.startTime &&
              status == other.status &&
              orderForAnother == other.orderForAnother &&
              costInRub == other.costInRub &&
              wishes == other.wishes &&
              cancelReason == other.cancelReason;

  @override
  int get hashCode =>
      from.hashCode ^
      to.hashCode ^
      employerId.hashCode ^
      driverId.hashCode ^
      distance.hashCode ^
      startTime.hashCode ^
      status.hashCode ^
      orderForAnother.hashCode ^
      costInRub.hashCode ^
      wishes.hashCode ^
      cancelReason.hashCode;
}
