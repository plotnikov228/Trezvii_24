import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';

abstract class AddAddressToFavoriteEvent {}

class OpenBottomSheetEvent extends AddAddressToFavoriteEvent {

}

class SelectAddressEvent extends AddAddressToFavoriteEvent {
  final AddressModel addressModel;

  SelectAddressEvent(this.addressModel);
}

class CheckAddressForExistence extends AddAddressToFavoriteEvent {
  final String text;
  final BuildContext context;
  final String name;
  final String addressName;
  final String entrance;
  final String comment;

  CheckAddressForExistence(this.text, this.context,
      {required this.name, required this.addressName, required this.entrance, required this.comment});

}

class ConfirmAddAddressEvent extends AddAddressToFavoriteEvent {
  final BuildContext context;

  final String name;
  final String addressName;
  final String entrance;
  final String comment;

  ConfirmAddAddressEvent(this.context, {required this.name, required this.addressName, required this.entrance, required this.comment});

}


