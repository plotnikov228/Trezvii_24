import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/order_card_for_driver.dart';

import '../../../../../../../utils/app_style_util.dart';
import '../../../../../../../utils/size_util.dart';
import '../../../../bloc/state/driver_state.dart';

class StartOrderDriverContent extends StatelessWidget {
  final StartOrderDriverMapState state;
  final Function()? onSelectOrderTap;

  const StartOrderDriverContent(
      {super.key, required this.state, this.onSelectOrderTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if(state.orderWithId == null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            state.orderWithId == null ? 'Заказ не выбран' : 'Текущий заказ',
            style: AppStyle.black16,),
        ), if(state.orderWithId != null)
          Center(
            child: OrderCardForDriver(order:state.orderWithId!, user: state.userModel,
                userPhotoUrl: state.photoUrl,
                fullInfo: true),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: state.orderWithId == null ? 0 : 10),
          child: Center(
            child: AppElevatedButton(text: state.orderWithId == null ? 'Перейти к выбору заказов'
                : 'Приступить к выполнению', width: size.width - 100,
                onTap: state.orderWithId == null ? onSelectOrderTap : () {
              context.read<MapBloc>().add(ProceedOrderMapEvent());
                }),
          ),
        ),

      ],
    );
  }
}
