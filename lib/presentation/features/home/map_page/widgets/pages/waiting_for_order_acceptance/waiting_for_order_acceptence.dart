import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/waiting_for_order_acceptance/contents/driver_content.dart';

import '../../../../../../utils/size_util.dart';
import '../../../bloc/bloc/bloc.dart';
import '../../../bloc/state/state.dart';
import 'contents/user_content.dart';

class WaitingForOrderAcceptanceWidget extends StatelessWidget {
  final WaitingForOrderAcceptanceMapState state;
  final MapBloc bloc;
  const WaitingForOrderAcceptanceWidget({super.key, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 40, right:  40),
        child: userContent(bloc)
      ),
    );
  }
}
