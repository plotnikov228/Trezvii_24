
import 'package:sober_driver_analog/domain/map/models/address_model.dart';

import '../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../domain/tutorial/models/tariff_model.dart';

abstract class TutorialState {}

class ChooseAddressTutorialState extends TutorialState {
  final AddressModel? firstAddress;
  final AddressModel? secondAddress;

  ChooseAddressTutorialState({this.firstAddress, this.secondAddress});
}

class ChooseTariffTutorialState extends TutorialState {
  final int selectedTariffIndex;
  final List<TariffModel>? tariffList;

  ChooseTariffTutorialState({this.selectedTariffIndex = 0, this.tariffList = const []});
}

class ChoosePayMethodTutorialState extends TutorialState {
  final List<PaymentUiModel> listPayments;
  final int selectedListPayments;
  ChoosePayMethodTutorialState(
      {this.listPayments = const [], this.selectedListPayments = 0});
}