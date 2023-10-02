import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

class UpdateUser {
  final FirebaseAuthRepository repository;

  UpdateUser(this.repository);

  Future call(String id,
          {String? number,
          bool? blocked,
          String? email,
          String? name,
          int? bonuses,
          List<double>? ratings}) async =>
      repository.updateUser(id,
          name: name,
          blocked: blocked,
          number: number,
          bonuses: bonuses,
          email: email,
          ratings: ratings);
}
