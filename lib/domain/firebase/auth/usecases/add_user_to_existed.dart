import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

import '../models/user_model.dart';

class AddUserToExisted {
  final FirebaseAuthRepository repository;

  AddUserToExisted(this.repository);

  Future call(UserModel userModel) async {
    return repository.addUserToExisted(userModel);
  }
}