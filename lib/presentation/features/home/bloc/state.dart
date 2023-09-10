
import 'package:flutter/cupertino.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';

import '../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../domain/tutorial/models/tariff_model.dart';

class HomeState {
  final PageController pageController;
  final int currentPage;
  HomeState(this.pageController, this.currentPage);
}