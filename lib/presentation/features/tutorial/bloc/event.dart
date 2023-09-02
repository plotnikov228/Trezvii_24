import 'package:flutter/cupertino.dart';

import '../../../../domain/map/models/address_model.dart';

abstract class TutorialEvent {}

class InitializeTutorialEvent extends TutorialEvent {}

class SkipTutorialEvent extends TutorialEvent {
  final BuildContext context;

  SkipTutorialEvent(this.context);
}

class ChooseAddressTutorialEvent extends TutorialEvent {
  final AddressModel? selectedAddress;

  ChooseAddressTutorialEvent(this.selectedAddress);
}

class ChooseTariffTutorialEvent extends TutorialEvent {
  final int selectedTariffIndex;

  ChooseTariffTutorialEvent(this.selectedTariffIndex);
}

class ChoosePayMethodTutorialEvent extends TutorialEvent {
  final int selectedPaymentMethodIndex;

  ChoosePayMethodTutorialEvent(this.selectedPaymentMethodIndex);
}