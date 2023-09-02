import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class CheckPermission {
  final MapRepository repository;

  CheckPermission(this.repository);

  Future<bool> call () {
    return repository.checkPermission();
  }
}