import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/ui/widgets/search_bottom_sheet.dart';

import '../../../../../data/map/repository/repository.dart';
import '../../../../../domain/map/models/app_lat_long.dart';
import '../../../../../domain/map/usecases/get_addresses_from_text.dart';
import '../../../../../domain/map/usecases/get_last_point.dart';

class SearchBottomSheetBloc extends Bloc<SearchBottomSheetEvent, SearchBottomSheetState> {

  AppLatLong? _point;
  final _mapRepo = MapRepositoryImpl();
  SearchBottomSheetBloc(super.initialState) {
    on<SearchAddressByTextEvent>((event, emit) async {
      _point ??= await GetLastPoint(_mapRepo).call();
      final addresses =
      await GetAddressesFromText(_mapRepo).call(event.text, _point!);
      emit(SearchBottomSheetState(addresses: addresses));
    });
  }

}