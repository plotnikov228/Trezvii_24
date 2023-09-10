import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_addresses_from_text.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';

import '../../../../data/map/repository/repository.dart';
import '../../../../domain/map/models/address_model.dart';
import '../../../../domain/map/usecases/get_last_point.dart';

class AddAddressToFavoriteBloc extends Bloc<AddAddressToFavoriteEvent, AddAddressToFavoriteState> {

  AddressModel? _addressModel;
  AppLatLong? _point;
  final _mapRepo = MapRepositoryImpl();

  AddAddressToFavoriteBloc(super.initialState) {


    on<SearchAddressByTextEvent>((event, emit) async {
      _point ??= await GetLastPoint(_mapRepo).call();
      final addresses = await GetAddressesFromText(_mapRepo).call(event.text, _point!);
      emit(AddAddressToFavoriteState(addresses: addresses));
    });
  }
}