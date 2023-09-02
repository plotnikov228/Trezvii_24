import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';

import '../../../../data/firebase/auth/models/driver.dart';
import '../../../../data/firebase/auth/models/user.dart';
import '../models/user_model.dart';

class SendDriverDataForVerification {
  final FirebaseAuthRepository repository;

  SendDriverDataForVerification(this.repository);

  Future<UserModel?> call(Driver userModel) async {
    return repository.sendDriverDataForVerification(userModel);
  }
}
