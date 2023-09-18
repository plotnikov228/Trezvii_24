import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/balance/bloc/state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {

  int _balance = 0;

  BalanceBloc(super.initialState) {
    on<InitBalanceEvent>((event, emit) async {

    });
  }

}