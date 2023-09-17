import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_addresses_from_text.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../data/map/repository/repository.dart';
import '../../../../domain/map/models/address_model.dart';
import '../../../../domain/map/usecases/get_last_point.dart';

class AddAddressToFavoriteBloc
    extends Bloc<AddAddressToFavoriteEvent, AddAddressToFavoriteState> {
  AddressModel? addressModel;
  AppLatLong? _point;
  final _mapRepo = MapRepositoryImpl();

  AddAddressToFavoriteBloc(super.initialState) {

    on<CheckAddressForExistence>((event, emit) async {
      _point ??= await GetLastPoint(_mapRepo).call();
      final addresses =
          (await GetAddressesFromText(_mapRepo).call(event.text, _point!));
      if (addresses.isEmpty) {
        AppSnackBar.showSnackBar(event.context,
            content: 'Такого адреса не существует');
      } else {
        addressModel = addresses.first;
        add(ConfirmAddAddressEvent(event.context,
            name: event.name,
            addressName: event.addressName,
            entrance: event.entrance,
            comment: event.comment));
      }
    });

    on<ConfirmAddAddressEvent>((event, emit) async {
      final newAddress = AddressModel(
          addressName: addressModel!.addressName,
          appLatLong: addressModel!.appLatLong,
          comment: event.comment,
          name: event.name,
          entrance: event.entrance);
      event.context.pop(newAddress);
    });

    on<SelectAddressEvent>((event, emit) async {
      addressModel = event.addressModel;
    });
  }
}
