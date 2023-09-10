import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

import '../../../map/models/app_lat_long.dart';
import '../models/car.dart';
import '../models/personal_data_of_the_driver.dart';

class UpdateDriver {
  final FirebaseAuthRepository repository;

  UpdateDriver(this.repository);

  Future call({
    String? number,
    String? email,
    String? name,
    AppLatLong? currentPosition,
    Car? car,
    PersonalDataOfTheDriver? personalDataOfTheDriver,
    List<int>? ratings,
  }) async =>
      repository.updateDriver(
          number: number,
          name: name,
          email: email,
          currentPosition: currentPosition,
          car: car,
          personalDataOfTheDriver: personalDataOfTheDriver,
          ratings: ratings);
}
