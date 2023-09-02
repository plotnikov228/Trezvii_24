import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/data/tutorial/repository/repository.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/payment/models/payment_ui_model.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_current_payment_models.dart';
import 'package:sober_driver_analog/domain/tutorial/models/tariff_model.dart';
import 'package:sober_driver_analog/domain/tutorial/usecases/get_list_tariff.dart';

import '../../../routes/routes.dart';
import 'event.dart';
import 'state.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final List<TutorialState> states = [
    ChooseAddressTutorialState(),
    ChooseTariffTutorialState(),
    ChoosePayMethodTutorialState()
  ];
  final _repo = TutorialRepositoryImpl();
  int currentStateIndex = 0;

  TutorialBloc(super.initialState) {
    final List<PaymentUiModel> _paymentModels =
        GetCurrentPaymentModels(PaymentRepositoryImpl()).call(false);

    on<SkipTutorialEvent>((event, emit) async {
      currentStateIndex++;
      if (currentStateIndex == states.length ) {
        event.context.pushReplacement(AppRoutes.splash);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('tutorial was completed', true);
      } else
      emit(states[currentStateIndex]);

    });
    late List<TariffModel> tariffs;
    int selectedTariffIndex = 0;
    int selectedMethodIndex = 0;
    on<InitializeTutorialEvent>((event, emit) async {
      try {
        tariffs = (await GetListTariff(_repo).call());
      } catch (_) {
        tariffs = [TariffModel('Трезвый водитель', 1999), TariffModel('Личный водитель', 6999)];
      }
        states[1] = ChooseTariffTutorialState(
            tariffList: tariffs, selectedTariffIndex: selectedTariffIndex);
       try {
        states[2] = ChoosePayMethodTutorialState(listPayments: _paymentModels, selectedListPayments: selectedMethodIndex);

      } catch (_) {

      }
    });

    AddressModel? firstAddress;
    AddressModel? secondAddress;

    on<ChooseAddressTutorialEvent>((event, emit) {
      if (event.selectedAddress != null) {
        firstAddress = event.selectedAddress;
      }
        firstAddress = event.selectedAddress;
      states[currentStateIndex] = ChooseAddressTutorialState(
          firstAddress: firstAddress, secondAddress: secondAddress);
      if(state is ChooseAddressTutorialState)
      emit(states[currentStateIndex]);
    });

    on<ChooseTariffTutorialEvent>((event, emit) {
      selectedTariffIndex = event.selectedTariffIndex;
      emit(ChooseTariffTutorialState(selectedTariffIndex: selectedTariffIndex, tariffList: tariffs));
    });


    on<ChoosePayMethodTutorialEvent>((event, emit) {
      selectedMethodIndex = event.selectedPaymentMethodIndex;
      emit(states[currentStateIndex]);
    });
  }
}
