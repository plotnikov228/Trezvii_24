import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

import '../models/user_model.dart';

class GetUserById {
  final FirebaseAuthRepository repository;

  GetUserById(this.repository);

  Future<UserModel?> call(String id) async {
    return repository.getUserById(id);
  }
}
