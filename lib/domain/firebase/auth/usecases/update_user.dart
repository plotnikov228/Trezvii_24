import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

class UpdateUser {
  final FirebaseAuthRepository repository;

  UpdateUser(this.repository);

  Future call (
      {String? number, String? email, String? name, int? bonuses}) async => repository.updateUser(name: name,number: number,bonuses: bonuses,email: email);
}