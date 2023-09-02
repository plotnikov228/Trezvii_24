import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

extension PointExtension on Point {
  AppLatLong toAppLatLong () {
    return AppLatLong(lat: latitude, long: longitude);
  }
}