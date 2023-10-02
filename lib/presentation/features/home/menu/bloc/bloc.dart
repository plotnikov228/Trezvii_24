import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/firebase/storage/repository.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/storage/usecases/get_photo_by_id.dart';
import 'package:sober_driver_analog/domain/payment/repository/repostitory.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_bonuses_balance.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/state.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';

import '../../../../../data/auth/repository/repository.dart';
import '../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../data/firebase/auth/repository.dart';
import '../../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../../../../domain/firebase/auth/usecases/get_user_by_id.dart';
import '../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../domain/payment/usecases/get_current_payment_ui_model.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  String? _userPhotoUrl;
  UserModel? _user;

  final _authRepo = AuthRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();
  final _paymentRepo = PaymentRepositoryImpl();
  int balance = 0;

  PaymentUiModel? _paymentUiModel;

  MenuBloc(super.initialState) {

    on<InitMenuEvent>((event, emit) async {
      final id = await GetUserId(_authRepo).call();

      final userFromDb = (await GetUserById(_firebaseAuthRepo).call(id));
        if(_user == null || (_user != null && _user!.name != userFromDb!.name || _user!.email != userFromDb!.email)) {
        _user = userFromDb;
        _paymentUiModel = await GetCurrentPaymentModel(_paymentRepo).call();
          _userPhotoUrl = await GetPhotoById(FirebaseStorageRepositoryImpl()).call(_user!.userId);

        balance = await GetBonusesBalance(PaymentRepositoryImpl()).call();
        print('username ${_user!.name}');
        emit(InitialMenuState(
            userModel: _user, userUrl: _userPhotoUrl, bonuses: balance));
      } else {
          emit(InitialMenuState(
              userModel: _user, userUrl: _userPhotoUrl, bonuses: balance));
        }
    });

    on<GoToProfileMenuEvent>((event, emit) async {
      event.context.pushNamed(AppRoutes.profile).then((value) => add(InitMenuEvent()));
    });

  on<GoMenuEvent>((event, emit) {
    if(event.newState is InitialMenuState) {
      emit(InitialMenuState(
          userModel: _user, userUrl: _userPhotoUrl, bonuses: balance));
    } else {
      emit(event.newState);
    }

  });

  }

}