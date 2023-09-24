import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../domain/payment/models/tariff.dart';

class StartOrderUserMapState extends StartOrderMapState {
  final int currentIndexTariff;
  final List<Tariff>? tariffList;
  final PaymentUiModel? currentPaymentUiModel;


  StartOrderUserMapState(
      {this.currentIndexTariff = 0, this.tariffList, this.currentPaymentUiModel, super.status, super.exception, super.message});

}