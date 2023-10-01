import 'package:flutter/material.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../../../domain/firebase/order/model/order.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/map/models/address_model.dart';
import '../../../../../utils/status_enum.dart';

abstract class MapState {
  final Status status;
  final String? exception;
  final String? message;

  MapState({this.message, this.exception, required this.status});

  MapState copyWith({Status? status, String? exception, String? message});
}

class InitialMapState extends MapState {

  final AddressModel? lastFavoriteAddress;

  InitialMapState({
    this.lastFavoriteAddress,
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  MapState copyWith({
    Status? status,
    String? exception,
    String? message,
  }) {
    return InitialMapState(
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class StartOrderMapState extends MapState {
  StartOrderMapState({
    String? exception,
    String? message,
    Status status = Status.Success,
  }) : super(exception: exception, status: status, message: message);

  @override
  MapState copyWith({
    Status? status,
    String? exception,
    String? message,
  }) {
    return StartOrderMapState(
     exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class SelectAddressesMapState extends MapState {
  final List<AddressModel> addresses;
  final List<AddressModel> favoriteAddresses;
  final int? autoFocusedIndex;

  SelectAddressesMapState({
    this.autoFocusedIndex,
    this.addresses = const [],
    this.favoriteAddresses = const [],
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  SelectAddressesMapState copyWith({
    List<AddressModel>? addresses,
    List<AddressModel>? favoriteAddresses,
    int? autoFocusedIndex,
    Status? status,
    String? exception,
    String? message,
  }) {
    return SelectAddressesMapState(
      addresses: addresses ?? this.addresses,
      favoriteAddresses: favoriteAddresses ?? this.favoriteAddresses,
      autoFocusedIndex: autoFocusedIndex ?? this.autoFocusedIndex,
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class SelectOrderMapState extends MapState {
  final Stream<List<OrderWithId>>? orders;
  final String locality;
  SelectOrderMapState( {this.locality = '',super.status = Status.Success, super.exception, this.orders, super.message});

  @override
  SelectOrderMapState copyWith({Status? status, String? exception, Stream<List<OrderWithId>>? orders, String? locality, String? message}) {
    return SelectOrderMapState(
        locality: locality ?? this.locality,
        message: message ?? this.message,
        status: status ?? this.status, exception: exception ?? this.exception, orders: orders ?? this.orders);
  }

}

class WaitingForOrderAcceptanceMapState extends MapState {
  WaitingForOrderAcceptanceMapState({
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  MapState copyWith({
    Status? status,
    String? exception,
    String? message,
  }) {
    return WaitingForOrderAcceptanceMapState(
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class CancelledOrderMapState extends MapState {
  final TextEditingController? otherReason;
  final String? orderId;
  final List<String> reasons;

  CancelledOrderMapState( {this.orderId,
    this.otherReason,
    this.reasons = const [],
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  CancelledOrderMapState copyWith({
    String? orderId,
    TextEditingController? otherReason,
    List<String>? reasons,
    Status? status,
    String? exception,
    String? message,
  }) {
    return CancelledOrderMapState(
      orderId: orderId ?? this.orderId,
      otherReason: otherReason ?? this.otherReason,
      reasons: reasons ?? this.reasons,
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class ActiveOrderMapState extends MapState {
  ActiveOrderMapState({
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  ActiveOrderMapState copyWith({
    Status? status,
    String? exception,
    String? message,
  }) {
    return ActiveOrderMapState(
      exception: exception ?? this.exception,
      status: status ?? this.status,
    );
  }
}

class OrderCompleteMapState extends MapState {
  final String? id;
  final String? orderId;
  OrderCompleteMapState({this.id, this.orderId, exception, status = Status.Success, super.message})
      : super(exception: exception, status: status);

  @override
  OrderCompleteMapState copyWith({String? id,String? orderId,  Status? status, String? exception, String? message}) {
    return OrderCompleteMapState(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      message: message ?? this.message,
      exception:exception??  super.exception,
      status: status?? super.status,
    );
  }
}

class OrderCancelledByDriverMapState extends MapState {
  final Driver? driver;

  OrderCancelledByDriverMapState({this.driver, exception, status = Status.Success, super.message})
      : super(exception: exception, status: status);

  @override
  OrderCancelledByDriverMapState copyWith({ Status? status,Driver? driver, String? exception, String? message}) {
    return OrderCancelledByDriverMapState(
      driver: driver ?? this.driver,
      message: message ?? this.message,
      exception: exception?? super.exception,
      status:status?? super.status,
    );
  }
}

class OrderAcceptedMapState extends MapState {
  final Driver? driver;
  final Duration? waitingTime;
  final String? distance;

  OrderAcceptedMapState({this.distance, this.driver, this.waitingTime, exception, status = Status.Success, super.message})
      : super(exception: exception, status: status);

  @override
  OrderAcceptedMapState copyWith({ Status? status,Driver? driver, Duration? waitingTime, String? distance, String? exception, String? message}) {
    return OrderAcceptedMapState(
      driver: driver ?? this.driver,
      message: message ?? this.message,

      waitingTime: waitingTime ?? this.waitingTime,
      distance: distance ?? this.distance,
      exception: exception?? super.exception,
      status:status?? super.status,
    );
  }
}

class SelectPaymentMethodMapState extends MapState {
  final List methods;

  SelectPaymentMethodMapState({this.methods = const [], exception, status = Status.Success, super.message})
      : super(exception: exception, status: status);

  @override
  SelectPaymentMethodMapState copyWith({ Status? status,List? methods, String? exception, String? message}) {
    return SelectPaymentMethodMapState(
      methods: methods ?? this.methods,      message: message ?? this.message,

      exception:exception??  super.exception,
      status:status?? super.status,
    );
  }
}

class CheckBonusesMapState extends MapState {
  final int balance;

  CheckBonusesMapState({this.balance = 0, message, exception, status = Status.Success})
      : super(message: message, exception: exception, status: status);

  @override
  CheckBonusesMapState copyWith({ Status? status,int? balance, String? exception, String? message}) {
    return CheckBonusesMapState(
      message: message ?? this.message,

      balance: balance ?? this.balance,
      exception: exception ?? super.exception,
      status:status?? super.status,
    );
  }
}

class PromoCodeMapState extends MapState {
  final TextEditingController? controller;

  PromoCodeMapState({this.controller, exception, status = Status.Success, message})
      : super(exception: exception, status: status, message: message);

  @override
  PromoCodeMapState copyWith({ Status? status,TextEditingController? controller, String? exception, String? message}) {
    return PromoCodeMapState(
      controller: controller ?? this.controller,
      message: message ?? this.message,
      exception: exception ??  super.exception,
      status:status?? super.status,
    );
  }
}

class AddCardMapState extends MapState {
  AddCardMapState({exception, status = Status.Success, super.message}) : super(exception: exception, status: status);

  @override
  AddCardMapState copyWith({
    Status? status, String? exception, String? message
  }) {
    return AddCardMapState(
      message: message ?? this.message,

      exception: exception ?? super.exception,
      status:status?? super.status,
    );
  }
}

class AddWishesMapState extends MapState {
  final TextEditingController? wish;
  final TextEditingController? otherName;
  final TextEditingController? otherNumber;

  AddWishesMapState({this.wish, this.otherName, this.otherNumber, exception, status = Status.Success, super.message})
      : super(exception: exception, status: status);

  @override
  MapState copyWith({ Status? status,TextEditingController? wish, TextEditingController? otherName, TextEditingController? otherNumber, String? exception, String? message}) {
    return AddWishesMapState(
      message: message ?? this.message,

      wish: wish ?? this.wish,
      otherName: otherName ?? this.otherName,
      otherNumber: otherNumber ?? this.otherNumber,
      exception: exception ?? super.exception,
      status:status?? super.status,
    );
  }
}

class ActiveOrdersMapState extends MapState {
  final List<OrderWithId>? orders;
  final List<UserModel?>? users;
  final Order? currentOrder;

  ActiveOrdersMapState({this.orders, this.users, this.currentOrder, status = Status.Success, super.message})
      : super(status: status);

  @override
  MapState copyWith({ Status? status,List<OrderWithId>? orders, List<UserModel?>? drivers, Order? currentOrder, String? exception,String? message}) {
    return ActiveOrdersMapState(
      orders: orders ?? this.orders,
      users: drivers ?? this.users,
      currentOrder: currentOrder ?? this.currentOrder,
      message: message ?? this.message,

      status:status?? super.status,
    );
  }
}

class AddPriceMapState extends MapState {
  final Order? order;

  AddPriceMapState({ super.status = Status.Success, this.order, super.message, super.exception});


  @override
  MapState copyWith({Status? status, Order? order, String? exception, String? message}) {
    return AddPriceMapState(
        status: status ?? this.status,
      message: message ?? this.message,
      order: order ?? this.order,
      exception: exception ?? this.exception
    );
  }

}