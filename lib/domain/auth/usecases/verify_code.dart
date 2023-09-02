import 'package:sober_driver_analog/domain/auth/models/auth_type.dart';

import '../models/auth_result.dart';
import '../repository/repository.dart';

class VerifyCode {
  final AuthRepository repository;

  VerifyCode(this.repository);

  Future<AuthResult> call (String code,  AuthResult result, {required Function(bool needSignUp) whenComplete, required AuthType type}) {
    return repository.verifyCode(code, result, whenComplete: whenComplete, type: type);
  }
}