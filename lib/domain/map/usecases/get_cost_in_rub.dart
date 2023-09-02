import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class GetCostInRub {
  final MapRepository repository;

  GetCostInRub(this.repository);

  Future<double> call (List<AppLatLong> points) {
    return repository.getCostInRub(points);
  }
}