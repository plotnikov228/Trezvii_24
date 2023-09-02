import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class GetAddressesFromText {
  final MapRepository repository;

  GetAddressesFromText(this.repository);

  Future<List<AddressModel>> call (String address, AppLatLong point) {
    return repository.getAddressesFromText(address, point);
  }
}