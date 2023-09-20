import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/menu_page.dart';

import '../../../utils/status_enum.dart';
import '../../../widgets/map/map_widget.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../map_page/map_page.dart';
import '../menu/bloc/event.dart';
import '../menu/bloc/state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=  PageController(initialPage: 1,);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (_) => HomeBloc(HomeState(controller, 1), controller)),
          BlocProvider<MapBloc>(
            create: (_) => MapBloc(InitialMapState(status: Status.Success))
              ..add(InitMapBloc()),
          ),
          BlocProvider<MenuBloc>(
              create: (_) => MenuBloc(InitialMenuState())..add(InitMenuEvent()))
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return PageView(
              clipBehavior: Clip.none,
              allowImplicitScrolling: true,
              physics: state.currentPage == 1 ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
              onPageChanged: (val) {
                bloc.add(UpdateHomeEvent(val));
                if(val == 1) {
                  Future.delayed(const Duration(seconds: 1), () {
                    final menuBloc = context.read<MenuBloc>();
                    if(menuBloc.state is! InitialMenuState){
                      menuBloc.add(GoMenuEvent(newState: InitialMenuState()));
                    }
                  });

                }
                },
              controller: state.pageController,
              children: const [
              MenuPage(),
              MapPage(),
            ],);



          },
        ),
      ),
    );
  }
}
