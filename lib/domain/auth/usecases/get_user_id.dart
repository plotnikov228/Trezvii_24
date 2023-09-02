import '../models/auth_result.dart';
import '../repository/repository.dart';

class GetUserId {
  final AuthRepository repository;

  GetUserId(this.repository);

  Future call<String> () {
    return repository.getUserId();
  }
}