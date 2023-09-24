import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

class UpdateUser {
  final FirebaseAuthRepository repository;

  UpdateUser(this.repository);

  Future call (
      String id,{String? number, String? email, String? name, int? bonuses}) async => repository.updateUser(id,name: name,number: number,bonuses: bonuses,email: email);
}