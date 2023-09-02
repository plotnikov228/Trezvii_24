import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/repository/repository.dart';

import '../models/address_model.dart';


class GetAddressFromPoint {
  final MapRepository repository;

  GetAddressFromPoint(this.repository);

  Future<AddressModel?> call(AppLatLong point) {
    return repository.getAddressFromPoint(point);
  }
}