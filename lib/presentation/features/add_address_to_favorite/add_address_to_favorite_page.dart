import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/ui/add_address_to_favorite_screen.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/search_bottom_sheet.dart';

class AddAddressToFavoritePage extends StatelessWidget {
  const AddAddressToFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    BlocProvider<AddAddressToFavoriteBloc>(create: (_) => AddAddressToFavoriteBloc(AddAddressToFavoriteState()),

      child: AddAddressToFavoriteScreen(),
    );
  }
}
