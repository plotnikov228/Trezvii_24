import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/domain/db/usecases/db_insert.dart';
import 'package:sober_driver_analog/domain/db/usecases/db_query.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/state.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';

import '../../../../../../domain/db/constants.dart';

class FavoriteAddressesBloc extends Bloc<FavoriteAddressesEvent, FavoriteAddressesState>{

  late final List<AddressModel> _addresses;
  final _dbRepo = DBRepositoryImpl();
  FavoriteAddressesBloc(super.initialState) {

    on<InitFavoriteAddressesEvent>((event, emit) async {
      _addresses = (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable)).map((e) => AddressModel.fromJson(e)).toList();
      emit(FavoriteAddressesState(_addresses));
    });

    on<GoToNewPageForAddNewAddressEvent>((event, emit) async {
      event.context.pushNamed<AddressModel?>(AppRoutes.addNewAddress).then((value) {
        if(value != null) {
          add(AddAddressEvent(value));
        }
      });
    });

    on<AddAddressEvent>((event, emit) async {
      print('new Address');
      await DBInsert(_dbRepo).call(DBConstants.favoriteAddressesTable, event.addressModel.toJson());
      _addresses.add(event.addressModel);
      emit(FavoriteAddressesState(_addresses));
    });
  }

}