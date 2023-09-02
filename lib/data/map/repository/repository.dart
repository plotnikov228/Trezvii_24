import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapRepositoryImpl extends MapRepository {

  static const defLocation = MoscowLocation();
  static const _lastLatKey = 'lastLatKey';
  static const _lastLongKey = 'lastLongKey';


  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
    value == LocationPermission.always ||
        value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<AppLatLong> getCurrentLocation() {
    return Geolocator.getCurrentPosition().then((value) {
      return AppLatLong(lat: value.latitude, long: value.longitude);
    }).catchError(
          (_) => defLocation,
    );
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
    value == LocationPermission.always ||
        value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<AppLatLong> getLastPoint() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_lastLatKey) ?? const MoscowLocation().lat;
    final long = prefs.getDouble(_lastLongKey) ?? const MoscowLocation().long;
    return AppLatLong(lat: lat, long: long);
  }

  @override
  Future setLastPoint(AppLatLong point) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lastLongKey, point.long);
    await prefs.setDouble(_lastLatKey, point.lat);
  }

  @override
  Future<AddressModel?> getAddressFromPoint(AppLatLong point) async {
    final p = point.toPoint();
    final result = YandexSearch.searchByPoint(
        point: p, searchOptions: const SearchOptions());
    final addressName =(await result.result).items?.first.name;

    if (addressName != null) return AddressModel(addressName: addressName, appLatLong: AppLatLong(lat: p.latitude, long: p.longitude));
    return null;
  }

  @override
  Future<List<AddressModel>> getAddressesFromText(String address, AppLatLong point) async {
    final result = YandexSearch.searchByText(
        searchText: address, searchOptions: const SearchOptions(), geometry: Geometry.fromPoint(point.toPoint()));
    final list = ((await result.result).items ?? []).map((e) => AddressModel(addressName: e.name, appLatLong: AppLatLong(lat: e.geometry.first.point!.latitude, long: e.geometry.first.point!.longitude))).toList();
    return list;
  }

  @override
  Future<List<DrivingRoute>?> getRoutes(List<AppLatLong> points) async {
    return (await YandexDriving.requestRoutes(points: points.map((e) => RequestPoint(point: e.toPoint(), requestPointType: RequestPointType.wayPoint)).toList(), drivingOptions: const DrivingOptions()).result).routes;
  }

  @override
  Future<Duration> getDurationBetweenTwoPoints(AppLatLong first, AppLatLong second) async {
    final route = (await YandexDriving.requestRoutes(points: [first, second].map((e) => RequestPoint(point: e.toPoint(), requestPointType: RequestPointType.wayPoint)).toList(), drivingOptions: const DrivingOptions()).result).routes;
    return Duration(minutes: route!.first.metadata.weight.timeWithTraffic.value!.toInt());
  }

  @override
  Future<double> getCostInRub(List<AppLatLong> points) async {
    AppLatLong? startPoint;
    AppLatLong? endPoint;
    for(var item in points) {

    }
    return 0.0;
  }

}