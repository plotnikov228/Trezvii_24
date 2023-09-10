
import 'package:flutter/cupertino.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/state.dart';

abstract class MenuEvent {}

class InitMenuEvent extends MenuEvent {

}

class GoToProfileMenuEvent extends MenuEvent {
    final BuildContext context;

  GoToProfileMenuEvent(this.context);
}

class GoMenuEvent extends MenuEvent {
  final MenuState newState;

  GoMenuEvent({required this.newState});
}