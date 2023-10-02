import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import '../../../../../../utils/size_util.dart';
import '../../../../../../widgets/map/location_button.dart';
import '../../../bloc/bloc/bloc.dart';
import 'contents/user_content.dart';


class OrderAcceptedWidget extends StatelessWidget {
  final OrderAcceptedMapState state;
  const OrderAcceptedWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    Timer(const Duration(seconds: 10), () {
      if(bloc.state is OrderAcceptedMapState) {
        bloc.add(GoMapEvent(OrderAcceptedMapState()));
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LocationButton(onTap: () => bloc.add(GoToCurrentPositionMapEvent())),
          ),),
        Container(
          height: 292,
          width: size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
              child:OrderAcceptedUserContent(state: state,)
          ),
        ),
      ],
    );
  }
}
