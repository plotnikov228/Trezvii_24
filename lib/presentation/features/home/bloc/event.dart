import 'package:flutter/cupertino.dart';

import '../../../../domain/map/models/address_model.dart';

abstract class HomeEvent {}

class UpdateHomeEvent extends HomeEvent {
  final int newPage;

  UpdateHomeEvent(this.newPage);
}

class GoToMenuHomeEvent extends HomeEvent {}

