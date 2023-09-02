import '../models/auth_result.dart';
import '../repository/repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future call (String number, String email, Function(AuthResult) onError, Function(AuthResult) onSuccess) {
    return repository.signUp(number, email, onError, onSuccess);
  }
}