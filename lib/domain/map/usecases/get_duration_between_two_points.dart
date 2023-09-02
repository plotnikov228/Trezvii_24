import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';
import 'package:sober_driver_analog/presentation/app.dart';

class GetDurationBetweenTwoPoints {
  final MapRepository repository;

  GetDurationBetweenTwoPoints(this.repository);

  Future<Duration> call (AppLatLong first, AppLatLong second) {
    return repository.getDurationBetweenTwoPoints(first, second);
  }
}