import '../../../data/firebase/auth/models/driver.dart';
import '../models/auth_result.dart';
import '../repository/repository.dart';

class SignUpForDriver {
  final AuthRepository repository;

  SignUpForDriver(this.repository);

  Future call (String number, Driver driver,
      {required Function(AuthResult) onError, required Function(AuthResult) onSuccess}) {
    return repository.signUpForDriver(number, driver, onError: onError, onSuccess: onSuccess);
  }
}