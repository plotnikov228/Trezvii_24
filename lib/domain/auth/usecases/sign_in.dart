import '../models/auth_result.dart';
import '../repository/repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future call (String number, Function(AuthResult) onError, Function(AuthResult) onSuccess) {
    return repository.signIn(number, onError, onSuccess);
  }
}