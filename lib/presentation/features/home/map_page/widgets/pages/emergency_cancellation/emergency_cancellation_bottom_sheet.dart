import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';

import '../../../../../../utils/size_util.dart';

class EmergencyCancellationBottomSheet extends StatelessWidget {
  const EmergencyCancellationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Container(
      height: 146,
      width: size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        color: Colors.white
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Вы экстренно отменили заказ'),
            AppElevatedButton(text: 'Продолжить', onTap: () => bloc.add(RecheckOrderMapEvent()))

          ],
        ),
      ),
    );
  }
}
