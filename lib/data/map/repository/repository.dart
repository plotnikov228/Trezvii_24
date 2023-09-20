import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_costs.dart';
import 'package:sober_driver_analog/extensions/point_extension.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../domain/payment/models/tariff.dart';

class MapRepositoryImpl extends MapRepository {
  static const defLocation = MoscowLocation();
  static const _lastLatKey = 'lastLatKey';
  static const _lastLongKey = 'lastLongKey';
  static const _locallyKey = 'locallyKey';

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
    final address = (await result.result).items?.first;

    if (address != null) {
      return AddressModel(
          addressName: address.name,
          appLatLong: AppLatLong(lat: p.latitude, long: p.longitude,
          ),
        entrance: address.toponymMetadata
            ?.address
            .addressComponents[SearchComponentKind.locality],
        locality: address.toponymMetadata
            ?.address
            .addressComponents[SearchComponentKind.locality]
      );
    }
    return null;
  }

  @override
  Future<List<AddressModel>> getAddressesFromText(
      String address, AppLatLong point) async {
    final result = YandexSearch.searchByText(
        searchText: address,
        searchOptions: const SearchOptions(),
        geometry: Geometry.fromPoint(point.toPoint()));
    final list = ((await result.result).items ?? [])
        .map((e) => AddressModel(
            addressName: e.name,
            locality: e.toponymMetadata?.address.addressComponents[SearchComponentKind.locality],
            appLatLong: e.geometry.first.point!.toAppLatLong()
        ,
        entrance: e.toponymMetadata
            ?.address
            .addressComponents[SearchComponentKind.locality],
    ))
        .toList();
    return list;
  }

  @override
  Future<List<DrivingRoute>?> getRoutes(List<AppLatLong> points) async {
    return (await YandexDriving.requestRoutes(
                points: points
                    .map((e) => RequestPoint(
                        point: e.toPoint(),
                        requestPointType: RequestPointType.wayPoint))
                    .toList(),
                drivingOptions: const DrivingOptions())
            .result)
        .routes;
  }

  @override
  Future<Duration> getDurationBetweenTwoPoints(
      AppLatLong first, AppLatLong second) async {
    final route = (await YandexDriving.requestRoutes(
                points: [first, second]
                    .map((e) => RequestPoint(
                        point: e.toPoint(),
                        requestPointType: RequestPointType.wayPoint))
                    .toList(),
                drivingOptions: const DrivingOptions())
            .result)
        .routes;
    return Duration(
        minutes: route!.first.metadata.weight.timeWithTraffic.value! ~/ 60);
  }

  @override
  Future<double> getCostInRub(Tariff tariff, DrivingRoute route) async {
    final points = route.geometry;
    Point? startPoint;

    final useCase = GetCosts(PaymentRepositoryImpl());
    int hours = route.metadata.weight.timeWithTraffic.value! / 60 ~/ 60;
    double tripPrice = await useCase.call(tariff, getStartPrice: true);
    final hourPrice = await useCase.call(tariff,getHourPrice: true);
    final kmPrice = await useCase.call(tariff, getKmPrice: true);
    final firstHoursPrice = await useCase.call(tariff, getPriceOfFirstHours: true);
    print('kmPrice - $kmPrice hourPrice - $hourPrice startPrice - $tripPrice first hour price - $firstHoursPrice');
    if(firstHoursPrice != 0 && tariff.hoursCount != null) {
      if(hours < tariff.hoursCount!) {
        hours = hours > 1 ? hours : 1;
        tripPrice += hours * firstHoursPrice;
        hours = 0;

      } else {
        tripPrice += 3 * firstHoursPrice;
        hours -= 3;
      }
    }
    final resultFirst = (await YandexSearch.searchByPoint(
            point: points.first, searchOptions: const SearchOptions())
        .result);

    final resultSecond = (await YandexSearch.searchByPoint(
            point: points.last, searchOptions: const SearchOptions())
        .result);
    final outCity = resultFirst.items!.first.toponymMetadata!.address
                .addressComponents[SearchComponentKind.locality] ==
            null ||
        resultFirst.items!.first.toponymMetadata!.address
                .addressComponents[SearchComponentKind.locality] !=
            resultSecond.items!.first.toponymMetadata!.address
                .addressComponents[SearchComponentKind.locality];


    if ((tariff.checkOutCity && outCity) || (!tariff.checkOutCity && kmPrice != 0)) {
      double distanceInKm = route.metadata.weight.distance.value! / 1000;
      print(distanceInKm);

      tripPrice += kmPrice * distanceInKm.round();
      print('trip price after add km tariff - $tripPrice');

    }
    if(hourPrice != 0) {
      tripPrice += hours * hourPrice;
    }

    print('trip price after add hour tariff - $tripPrice');

    return tripPrice.round().toDouble();
  }

  @override
  Future<String?> getLocally() async {
    final prefs = await SharedPreferences.getInstance();
   return prefs.getString(_locallyKey);
  }

  @override
  Future<String> setLocally(String locally) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locallyKey, locally);
    return locally;
  }
}
