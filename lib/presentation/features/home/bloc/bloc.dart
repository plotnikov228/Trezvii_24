import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_current_payment_ui_model.dart';
import '../../../../domain/payment/models/payment_ui_model.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final  PageController pageController;

  late PaymentUiModel paymentUiModel;

  HomeBloc(super.initialState, this.pageController) {


    on<GoToMenuHomeEvent>((event, emit) async {
      paymentUiModel = await GetCurrentPaymentModel(PaymentRepositoryImpl()).call();
      pageController.jumpToPage(0);

      add(UpdateHomeEvent(0));
    });

    on<UpdateHomeEvent>((event, emit) => emit(HomeState(pageController, event.newPage)));
  }
}
