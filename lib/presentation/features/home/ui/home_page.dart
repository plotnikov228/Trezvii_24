import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/state/state.dart';

import '../../../utils/status_enum.dart';
import '../../../widgets/map/map_widget.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import 'map_page/map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
              create: (_) => HomeBloc(MapHomeState())),
          BlocProvider<MapBloc>(
              create: (_) => MapBloc(InitialMapState(status: Status.Success))..add(InitMapBloc())),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return const MapPage();
          },
        ),
      ),
    );
  }
}
