import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../utils/app_style_util.dart';
import '../../../../bloc/state/driver_state.dart';

class StartOrderDriverContent extends StatelessWidget {
  final StartOrderDriverMapState state;
  const StartOrderDriverContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(state.orderWithId == null ? 'Заказ не выбран' : 'Текущий заказ', style: AppStyle.black16,),
        ),
        if()

      ],
    );
  }
}
