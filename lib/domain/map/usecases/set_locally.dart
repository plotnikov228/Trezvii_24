import 'package:sober_driver_analog/domain/map/repository/repository.dart';

class SetLocally {
  final MapRepository repository;

  SetLocally(this.repository);

  Future<String> call (String locally) {
    return repository.setLocally(locally);
  }
}