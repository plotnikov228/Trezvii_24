import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class GetCurrentLocation {
  final MapRepository repository;

  GetCurrentLocation(this.repository);

  Future<AppLatLong> call () {
    return repository.getCurrentLocation();
  }
}