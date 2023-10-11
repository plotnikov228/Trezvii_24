import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../../domain/map/models/app_lat_long.dart';
import '../../../../../../../domain/payment/models/card.dart';
import '../../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../domain/firebase/order/model/order.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';

abstract class MapEvent {}

class InitMapBloc extends MapEvent {}

class GetAddressMapEvent extends MapEvent {
  final AddressModel? selectedAddress;
  final int whichAddressShouldReplace;
  GetAddressMapEvent(this.selectedAddress, {this.whichAddressShouldReplace = 1});
}

class SearchAddressMapEvent extends MapEvent {
  final String address;
  final int index;
  SearchAddressMapEvent(this.address, this.index,);
}

class GoMapEvent extends MapEvent {
  final MapState newState;

  GoMapEvent(this.newState);
}

class GoToCurrentPositionMapEvent extends MapEvent {

}


class ChooseTariffMapEvent extends MapEvent {
  final int selectedTariffIndex;

  ChooseTariffMapEvent(this.selectedTariffIndex);
}

class ChoosePayMethodMapEvent extends MapEvent {
  final int selectedPaymentMethodIndex;

  ChoosePayMethodMapEvent(this.selectedPaymentMethodIndex);
}

class CreateOrderMapEvent extends MapEvent {}

class RecheckOrderMapEvent extends MapEvent {
  final String? id;
  final Order? order;

  RecheckOrderMapEvent({ this.id,  this.order});
}

class CancelOrderMapEvent extends MapEvent {
  final String reason;
  final String? id;

  CancelOrderMapEvent(this.id,this.reason);
}

class CheckPromoMapEvent extends MapEvent {
}

class UseBonusesMapEvent extends MapEvent {
  final int bonuses;

  UseBonusesMapEvent(this.bonuses);
}

class AddCardMapEvent extends MapEvent {
}

class GetOtherFromContactsMapEvent extends MapEvent {
  final BuildContext context;

  GetOtherFromContactsMapEvent(this.context);
}

class AddPreliminaryTimeMapEvent extends MapEvent {
  final DateTime? preliminaryTime;
  final bool preliminary;

  AddPreliminaryTimeMapEvent(this.preliminaryTime, this.preliminary);
}

class OnPaymentTapMapEvent extends MapEvent {
  final BuildContext context;
  final PaymentUiModel paymentUiModel;
  final UserCard? card;

  OnPaymentTapMapEvent(this.context, this.paymentUiModel, {this.card});
}

class CancelSearchMapEvent extends MapEvent {
final String? id;

  CancelSearchMapEvent({this.id});
}

class ChangeCostMapEvent extends MapEvent {
  final double changedCost;

  ChangeCostMapEvent(this.changedCost);
}

class GoToChatMapEvent extends MapEvent {
  final BuildContext context;

  GoToChatMapEvent(this.context);
}

class SelectOrderMapEvent extends MapEvent {
  final OrderWithId order;

  SelectOrderMapEvent(this.order);
}

class ProceedOrderMapEvent extends MapEvent {

}

class CompleteOrderMapEvent extends MapEvent {
  final double? rating;
  final String? id;
  final String? orderId;
  CompleteOrderMapEvent( {this.id, this.rating, this.orderId});
}

class EmergencyCancelMapEvent extends MapEvent {

}

class PaymentOfThePenaltyMapEvent extends MapEvent {
  final Penalty penalty;
  final UserCard? card;

  PaymentOfThePenaltyMapEvent(this.penalty, {this.card});
}