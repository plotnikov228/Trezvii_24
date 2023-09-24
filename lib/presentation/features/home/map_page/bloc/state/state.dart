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

  MapState copyWith({Status? status, String? exception});
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
  }) : super(exception: exception, status: status);

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
  SelectOrderMapState( {this.locality = '',super.status = Status.Success, super.exception, this.orders});

  @override
  SelectOrderMapState copyWith({Status? status, String? exception, Stream<List<OrderWithId>>? orders, String? locality}) {
    return SelectOrderMapState(
        locality: locality ?? this.locality,
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
  final List<String> reasons;

  CancelledOrderMapState({
    this.otherReason,
    this.reasons = const [],
    String? exception,
    Status status = Status.Success,
  }) : super(exception: exception, status: status);

  @override
  CancelledOrderMapState copyWith({
    TextEditingController? otherReason,
    List<String>? reasons,
    Status? status,
    String? exception,
    String? message,
  }) {
    return CancelledOrderMapState(
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
  final Driver? driver;

  OrderCompleteMapState({this.driver, exception, status = Status.Success})
      : super(exception: exception, status: status);

  @override
  OrderCompleteMapState copyWith({Driver? driver, Status? status, String? exception}) {
    return OrderCompleteMapState(
      driver: driver ?? this.driver,
      exception:exception??  super.exception,
      status: status?? super.status,
    );
  }
}

class OrderCancelledByDriverMapState extends MapState {
  final Driver? driver;

  OrderCancelledByDriverMapState({this.driver, exception, status = Status.Success})
      : super(exception: exception, status: status);

  @override
  OrderCancelledByDriverMapState copyWith({ Status? status,Driver? driver, String? exception}) {
    return OrderCancelledByDriverMapState(
      driver: driver ?? this.driver,
      exception: exception?? super.exception,
      status:status?? super.status,
    );
  }
}

class OrderAcceptedMapState extends MapState {
  final Driver? driver;
  final Duration? waitingTime;
  final String? distance;

  OrderAcceptedMapState({this.distance, this.driver, this.waitingTime, exception, status = Status.Success})
      : super(exception: exception, status: status);

  @override
  OrderAcceptedMapState copyWith({ Status? status,Driver? driver, Duration? waitingTime, String? distance, String? exception}) {
    return OrderAcceptedMapState(
      driver: driver ?? this.driver,
      waitingTime: waitingTime ?? this.waitingTime,
      distance: distance ?? this.distance,
      exception: exception?? super.exception,
      status:status?? super.status,
    );
  }
}

class SelectPaymentMethodMapState extends MapState {
  final List methods;

  SelectPaymentMethodMapState({this.methods = const [], exception, status = Status.Success})
      : super(exception: exception, status: status);

  @override
  SelectPaymentMethodMapState copyWith({ Status? status,List? methods, String? exception}) {
    return SelectPaymentMethodMapState(
      methods: methods ?? this.methods,
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
  CheckBonusesMapState copyWith({ Status? status,int? balance, String? exception}) {
    return CheckBonusesMapState(
      balance: balance ?? this.balance,
      message: super.message,
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
  PromoCodeMapState copyWith({ Status? status,TextEditingController? controller, String? exception}) {
    return PromoCodeMapState(
      controller: controller ?? this.controller,
      exception: exception ??  super.exception,
      status:status?? super.status,
      message: super.message,
    );
  }
}

class AddCardMapState extends MapState {
  AddCardMapState({exception, status = Status.Success}) : super(exception: exception, status: status);

  @override
  AddCardMapState copyWith({
    Status? status, String? exception
  }) {
    return AddCardMapState(
      exception: exception ?? super.exception,
      status:status?? super.status,
    );
  }
}

class AddWishesMapState extends MapState {
  final TextEditingController? wish;
  final TextEditingController? otherName;
  final TextEditingController? otherNumber;

  AddWishesMapState({this.wish, this.otherName, this.otherNumber, exception, status = Status.Success})
      : super(exception: exception, status: status);

  @override
  MapState copyWith({ Status? status,TextEditingController? wish, TextEditingController? otherName, TextEditingController? otherNumber, String? exception}) {
    return AddWishesMapState(
      wish: wish ?? this.wish,
      otherName: otherName ?? this.otherName,
      otherNumber: otherNumber ?? this.otherNumber,
      exception: exception ?? super.exception,
      status:status?? super.status,
    );
  }
}

class ActiveOrdersMapState extends MapState {
  final List? orders;
  final List<UserModel?>? users;
  final Order? currentOrder;

  ActiveOrdersMapState({this.orders, this.users, this.currentOrder, status = Status.Success})
      : super(status: status);

  @override
  MapState copyWith({ Status? status,List? orders, List<UserModel?>? drivers, Order? currentOrder, String? exception}) {
    return ActiveOrdersMapState(
      orders: orders ?? this.orders,
      users: drivers ?? this.users,
      currentOrder: currentOrder ?? this.currentOrder,
      status:status?? super.status,
    );
  }
}

class AddPriceMapState extends MapState {
  final Order? order;

  AddPriceMapState({ super.status = Status.Success, this.order});


  @override
  MapState copyWith({Status? status, Order? order, String? exception}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

}