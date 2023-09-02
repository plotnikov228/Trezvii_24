import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/firebase/auth/models/driver.dart';
import 'auth_type.dart';

class AuthResult {
  final String exception;
  final bool successful;
  final String? verificationId;
  final String? mail;
  final String? number;
  final AuthType? authType;
  final Driver? driver;


  AuthResult(    {this.driver, this.authType,this.verificationId, this.number, this.mail, this.exception = '', this.successful = true});
}