
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/map/usecases/position_stream.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/addresses_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/driver_position_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/map_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/order_changes_functions.dart';

import '../../../../../domain/firebase/auth/usecases/update_driver.dart';
import 'bloc/bloc.dart';
import 'functions/payments_functions.dart';

class MapBlocFunctions {
  final MapBloc bloc;
  MapBlocFunctions(this.bloc) {
    driverPositionFunctions = DriverPositionFunctions(bloc);
    orderFunctions = OrderChangesFunctions(bloc, this);
    paymentsFunctions = PaymentsFunctions();
    addressesFunctions = AddressesFunctions(bloc);
    mapFunctions = MapFunctions(bloc);
  }

  late final DriverPositionFunctions driverPositionFunctions;
  late final OrderChangesFunctions orderFunctions;
  late final PaymentsFunctions paymentsFunctions;
  late final AddressesFunctions addressesFunctions;
  late final MapFunctions mapFunctions;

  Future userInit () async {
    await addressesFunctions.init();
    await addressesFunctions.initLocalities();
    print(' localities - ${addressesFunctions.localities}');
    await paymentsFunctions.init();
    await orderFunctions.initForUser();
    }

    Future driverInit () async {
      await addressesFunctions.initLocalities();
      print(' localities - ${addressesFunctions.localities}');
      await orderFunctions.initForDriver();
      PositionStream(MapRepositoryImpl()).call().listen((event) {
        UpdateDriver(FirebaseAuthRepositoryImpl()).call(FirebaseAuth.instance.currentUser!.uid, currentPosition: event);
      });
    }
}


