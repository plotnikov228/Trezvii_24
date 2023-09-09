import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../../domain/map/models/app_lat_long.dart';
import '../../../../../../../domain/payment/models/card.dart';
import '../../../../../../../domain/payment/models/payment_ui_model.dart';

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


class ChooseTariffMapEvent extends MapEvent {
  final int selectedTariffIndex;

  ChooseTariffMapEvent(this.selectedTariffIndex);
}

class ChoosePayMethodMapEvent extends MapEvent {
  final int selectedPaymentMethodIndex;

  ChoosePayMethodMapEvent(this.selectedPaymentMethodIndex);
}

class CreateOrderMapEvent extends MapEvent {}

class RecheckOrderMapEvent extends MapEvent {}

class CancelOrderMapEvent extends MapEvent {
  final String reason;

  CancelOrderMapEvent(this.reason);
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

}

class ChangeCostMapEvent extends MapEvent {
  final double changedCost;

  ChangeCostMapEvent(this.changedCost);
}