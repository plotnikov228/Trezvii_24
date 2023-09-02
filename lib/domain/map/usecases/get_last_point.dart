import 'package:sober_driver_analog/domain/map/repository/repository.dart';

import '../models/app_lat_long.dart';

class GetLastPoint {
  final MapRepository repository;

  GetLastPoint(this.repository);

  Future<AppLatLong> call () {
    return repository.getLastPoint();
  }
}