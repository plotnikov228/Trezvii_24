import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/state.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final bool textFieldHasError;

  SignInEvent({this.textFieldHasError = false});
}

class SignUpEvent extends AuthEvent {
  final bool? updatedCheckBoxValue;
  final bool textFieldHasError;

  SignUpEvent({this.textFieldHasError = false, this.updatedCheckBoxValue});
}

class InputCodeAuthEvent extends AuthEvent {
  final BuildContext context;

  InputCodeAuthEvent(this.context);
}

class ChangeAuthStateEvent extends AuthEvent {
  final AuthState state;

  ChangeAuthStateEvent(this.state);
}

class CreateRequestEvent extends AuthEvent {

}

class InsertPhotoEvent extends AuthEvent {
  final int fileIndex;
  final ImageSource source;
  InsertPhotoEvent(this.fileIndex, this.source);
}
