import 'package:sober_driver_analog/domain/map/repository/repository.dart';

import '../models/app_lat_long.dart';

class SetLastPoint {
  final MapRepository repository;

  SetLastPoint(this.repository);

  Future call (AppLatLong point) {
    return repository.setLastPoint(point);
  }
}