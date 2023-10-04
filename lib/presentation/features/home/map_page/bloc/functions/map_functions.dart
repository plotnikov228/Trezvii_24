import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_driver.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_address_from_point.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_routes.dart';
import 'package:sober_driver_analog/domain/map/usecases/position_stream.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../../../domain/map/models/address_model.dart';
import '../../../../../../domain/map/models/app_lat_long.dart';
import '../bloc/bloc.dart';
import '../event/event.dart';

class MapFunctions {
  final MapBloc bloc;
  MapFunctions(this.bloc);



  StreamSubscription<AppLatLong>? _currentPosition;
  StreamController<DrivingRoute>? _routeStream;
  Stream<DrivingRoute>? get positionStream => _routeStream?.stream;
  DrivingRoute? lastRoute;

  final _repo = MapRepositoryImpl();
  final _fbRepo = FirebaseAuthRepositoryImpl();
  void initPositionStream ({bool driverMode = false, AppLatLong? to, Function()? whenComplete}) {
    _routeStream = StreamController.broadcast();
    _currentPosition = PositionStream(_repo).call().listen((event) async {
     print('changed position');

     if(to != null) {

        final routes = await GetRoutes(_repo)
            .call([event, to]);
        print('from localities func - ${routes?.first.geometry.length}');
        try {
          lastRoute = routes!.first;
          _routeStream!.add(routes!.first);
        } catch (_) {

        }
        if((routes!.first.metadata.weight.distance.value ?? 50) <= 50 && whenComplete != null) whenComplete();
      }
   });
  }

  void disposePositionStream () {
    if(_currentPosition != null) _currentPosition!.cancel();
    _currentPosition = null;
    _routeStream = null;
  }

  Future<AddressModel?> getCurrentAddress () async {
      final pos = await Geolocator.getLastKnownPosition();
      if(pos != null) {
        return await GetAddressFromPoint(_repo).call(AppLatLong(lat: pos.latitude, long: pos.longitude));
      }
  }

  Future<AppLatLong?> getCurrentPosition () async {
    final pos = await Geolocator.getLastKnownPosition();
    if(pos != null) {
      return AppLatLong(lat: pos.latitude, long: pos.longitude);
    }
  }

}