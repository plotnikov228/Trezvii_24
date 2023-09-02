import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

import '../../../../data/firebase/auth/models/user.dart';
import '../models/user_model.dart';

class CreateUser {
  final FirebaseAuthRepository repository;

  CreateUser(this.repository);

  Future<UserModel?> call(User userModel) async {
    return repository.createUser(userModel);
  }
}
