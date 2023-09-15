import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_app/about_app_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/about_company_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_tariffs/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_tariffs/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_tariffs/ui/about_tariffs_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/favorite_addresses_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/feedback/feedback_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/ui/news_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/orders_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/settings_page.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/ui/menu_screen.dart';
import '../../../utils/status_enum.dart';
import 'about_tariffs/bloc/state.dart';
import 'favorite_addresses/bloc/bloc.dart';
import 'favorite_addresses/bloc/event.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(create: (_) => OrdersBloc(OrdersState())..add(InitOrdersEvent())),
        BlocProvider<FavoriteAddressesBloc>(create: (_) => FavoriteAddressesBloc(FavoriteAddressesState([]))..add(InitFavoriteAddressesEvent())),
        BlocProvider<AboutCompanyBloc>(create: (_) => AboutCompanyBloc(AboutCompanyState())..add(InitAboutCompanyEvent())),
        BlocProvider<AboutTariffsBloc>(create: (_) => AboutTariffsBloc(AboutTariffsState(status: Status.Loading))..add(InitAboutTariffsEvent())),
        BlocProvider<NewsBloc>(create: (_) => NewsBloc(NewsState(status: Status.Loading))..add(InitNewsEvent())),
        BlocProvider<SettingsBloc>(create: (_) => SettingsBloc(SettingsState())..add(InitSettingsEvent())),



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
          if(state is AboutCompanyMenuState) {
            return const AboutCompanyPage();
          }
          if(state is AboutTariffsMenuState) {
            return const AboutTariffsPage();
          } if (state is NewsMenuState) {
            return const NewsPage();
          } if(state is FeedbackMenuState) {
            return const FeedbackPage();
          } if(state is AboutAppMenuState) {
            return const AboutAppPage();
          } if(state is SettingsMenuState) {
            return const SettingsPage();
          }
          return MenuScreen(bloc: bloc, state: state as InitialMenuState,);
        },
      ),
    );
  }
}
