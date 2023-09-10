import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class InitProfileEvent extends ProfileEvent {}

class ChangePhotoProfileEvent extends ProfileEvent {
  final ImageSource source;

  ChangePhotoProfileEvent(this.source);

}

class CompleteChangesProfileEvent extends ProfileEvent {}