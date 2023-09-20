
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/driver_position_functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions/order_changes_functions.dart';

import 'bloc/bloc.dart';

class MapBlocFunctions {
  final MapBloc bloc;
  MapBlocFunctions(this.bloc) {
    driverPositionFunctions = DriverPositionFunctions(bloc);
    orderChangesFunctions = OrderChangesFunctions(bloc);
  }

  late final DriverPositionFunctions driverPositionFunctions;
  late final OrderChangesFunctions orderChangesFunctions;

}
