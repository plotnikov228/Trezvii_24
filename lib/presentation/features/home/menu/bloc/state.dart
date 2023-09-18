import 'package:sober_driver_analog/domain/firebase/auth/models/user_model.dart';

import '../../../../../domain/payment/models/payment_ui_model.dart';

abstract class MenuState {
}

class InitialMenuState extends MenuState {
  final UserModel? userModel;
  final String? userUrl;
  final int bonuses;
  final PaymentUiModel? currentPaymentModel;

  InitialMenuState({this.bonuses = 0, this.userModel, this.userUrl, this.currentPaymentModel});
}

class OrdersMenuState extends MenuState {}

class FavoriteAddressesMenuState extends MenuState {}

class AboutCompanyMenuState extends MenuState {}

class AboutTariffsMenuState extends MenuState {}

class NewsMenuState extends MenuState {}

class FeedbackMenuState extends MenuState {}

class SettingsMenuState extends MenuState {}

class AboutAppMenuState extends MenuState {}

class BalanceMenuState extends MenuState {}

