import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

class UserIsExist {
  final FirebaseAuthRepository repository;

  UserIsExist(this.repository);

  Future<bool> call(String number) async {
    return repository.userIsExist(number);
  }
}