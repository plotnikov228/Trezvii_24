
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/addresses_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/driver_position_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/map_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/order_changes_functions.dart';

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
    await paymentsFunctions.init();
    await orderFunctions.initForUser();
    }

    Future driverInit () async {
      await orderFunctions.initForDriver();
      mapFunctions.initPositionStream(driverMode: true,);
    }
}


