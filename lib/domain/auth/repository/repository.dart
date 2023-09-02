import 'package:firebase_auth/firebase_auth.dart';
import 'package:sober_driver_analog/data/firebase/auth/models/driver.dart';

import '../models/auth_result.dart';
import '../models/auth_type.dart';

abstract class AuthRepository {
  Future signUp(String name, String email, Function(AuthResult) onError, Function(AuthResult) onSuccess);

  Future signIn(String number, Function(AuthResult) onError, Function(AuthResult) onSuccess);

  Future<AuthResult> verifyCode (String code, AuthResult authResult, {required Function(bool) whenComplete, required AuthType type});

  Future signUpForDriver (String number, Driver driver,
      {required Function(AuthResult) onError, required Function(AuthResult) onSuccess});

  Future<String> getUserId ();
}