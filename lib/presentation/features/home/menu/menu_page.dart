import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/favorite_addresses_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/orders_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/ui/menu_screen.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/state.dart';

import 'favorite_addresses/bloc/bloc.dart';
import 'favorite_addresses/bloc/event.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(create: (_) => OrdersBloc(OrdersState())..add(InitOrdersEvent())),
        BlocProvider<FavoriteAddressesBloc>(create: (_) => FavoriteAddressesBloc(FavoriteAddressesState([]))..add(InitFavoriteAddressesEvent()))
      ],
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (BuildContext context, MenuState state) {
          final bloc = context.read<MenuBloc>();
          if(state is OrdersMenuState) {
            return const OrdersPage();
          }
          if(state is FavoriteAddressesMenuState) {
            return const FavoriteAddressesPage();
          }
          return MenuScreen(bloc: bloc, state: state as InitialMenuState,);
        },
      ),
    );
  }
}
