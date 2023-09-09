import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../payment/models/tariff.dart';

class GetCostInRub {
  final MapRepository repository;

  GetCostInRub(this.repository);

  Future<double> call (Tariff tariff,DrivingRoute route) {
    return repository.getCostInRub( tariff,route);
  }
}