import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/utils/status_enum.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../../../../domain/payment/models/card.dart' as c;
import '../../../../../../../domain/payment/models/payment_ui_model.dart';

import '../../../../../../../domain/tutorial/models/tariff_model.dart';

abstract class MapState {
  final Status status;
  final String? exception;
  final String? message;

  MapState( {this.message,this.exception, required this.status});
}

class InitialMapState extends MapState {
  InitialMapState({
    super.exception,
    super.status = Status.Success,
  });
}

class CreateOrderMapState extends MapState {
  final int currentIndexTariff;
  final List<TariffModel>? tariffList;
  final PaymentUiModel? currentPaymentUiModel;

  CreateOrderMapState({
    this.tariffList,
    this.currentIndexTariff = 0,
    this.currentPaymentUiModel,
    super.exception,
    super.status = Status.Success,
  });
}

class SelectAddressesMapState extends MapState {
  final List<AddressModel> addresses;
  final List<AddressModel> favoriteAddresses;
  final int? autoFocusedIndex;

  SelectAddressesMapState(
      {this.autoFocusedIndex,
      this.addresses = const [],
      this.favoriteAddresses = const [],
      super.exception,
      super.status = Status.Success});
}

class WaitingForOrderAcceptanceMapState extends MapState {
  WaitingForOrderAcceptanceMapState(
      {super.exception, super.status = Status.Success});
}

class CancelledOrderMapState extends MapState {
  final TextEditingController? otherReason;
  final List<String> reasons;

  CancelledOrderMapState(
      {this.otherReason,
      this.reasons = const [],
      super.exception,
      super.status = Status.Success});
}

class ActiveOrderMapState extends MapState {
  ActiveOrderMapState({super.exception, super.status = Status.Success});
}

class OrderCompleteMapState extends MapState {
  final Driver? driver;
  OrderCompleteMapState({this.driver, super.exception, super.status = Status.Success});
}

class OrderCancelledByDriverMapState extends MapState {
  final Driver? driver;
  OrderCancelledByDriverMapState(
      {this.driver, super.exception, super.status = Status.Success});
}

class OrderAcceptedMapState extends MapState {
  final Driver? driver;
  final Duration? waitingTime;

  OrderAcceptedMapState(
      {this.driver, this.waitingTime,super.exception, super.status = Status.Success});
}

class SelectPaymentMethodMapState extends MapState {
  final List<PaymentUiModel> methods;

  SelectPaymentMethodMapState(
      {this.methods = const [],
      super.exception,
      super.status = Status.Success});
}

class CheckBonusesMapState extends MapState {
  final int balance;

  CheckBonusesMapState(
      {this.balance = 0, super.message, super.exception, super.status = Status.Success});
}

class PromoCodeMapState extends MapState {
  final TextEditingController? controller;

  PromoCodeMapState(
      {this.controller,super.exception, super.status = Status.Success, super.message});
}

class AddCardMapState extends MapState {
  AddCardMapState({super.exception, super.status = Status.Success});
}

class AddWishesMapState extends MapState {
  final TextEditingController? wish;
  final TextEditingController? otherName;
  final TextEditingController? otherNumber;

  AddWishesMapState(
      {this.wish,
      this.otherName,
      this.otherNumber,
      super.exception,
      super.status = Status.Success});
}
