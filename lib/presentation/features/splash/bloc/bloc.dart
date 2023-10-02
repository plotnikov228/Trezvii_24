import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/domain/db/usecases/init_db.dart';
import 'package:sober_driver_analog/presentation/features/splash/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/splash/bloc/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sober_driver_analog/presentation/routes/router.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(super.initialState) {

    on<InitializeAppInSplashEvent>((event, emit) async {
      //initialize
      await Firebase.initializeApp();
      //await FirebaseAppCheck.instance.activate();
      await InitDB(DBRepositoryImpl()).call();
      try {
        late StreamSubscription<User?> listener;
        listener = FirebaseAuth.instance.authStateChanges().listen((user) {
          Timer(const Duration(seconds: 2),() async {
            bool authorized = true;
            if (user == null) {
              authorized = false;
            }
            event.context.pushReplacement(await AppRouter().getStartLocation(authorized));
            listener.cancel();
          });

        });
      } catch (_) {
        event.context.pushReplacementNamed(AppRoutes.auth);
      }

    });

  }

}