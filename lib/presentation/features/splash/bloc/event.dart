import 'package:flutter/cupertino.dart';

abstract class SplashEvent {}

class InitializeAppInSplashEvent extends SplashEvent {
  final BuildContext context;

  InitializeAppInSplashEvent(this.context);
}