import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class RequestPermission {
  final MapRepository repository;

  RequestPermission(this.repository);

  Future<bool> call () {
    return repository.requestPermission();
  }
}