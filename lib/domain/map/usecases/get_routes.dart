import 'package:sober_driver_analog/domain/map/repository/repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../models/app_lat_long.dart';

class GetRoutes {
  final MapRepository repository;

  GetRoutes(this.repository);

  Future<List<DrivingRoute>?> call (List<AppLatLong> points) {
    return repository.getRoutes(points);
  }
}