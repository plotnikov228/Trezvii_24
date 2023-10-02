import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';

import '../../../../../../utils/size_util.dart';

class EmergencyCancellationMessage extends StatelessWidget {
  final Function()? onAccept;
  final Function()? onCancel;

  const EmergencyCancellationMessage({Key? key, this.onAccept, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: size.width > 500 ? 500 : size.width - 40,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Вы уверены, что хотите екстренно отменить заказ? Если вы это сделаете с вашего счёта будет списано 500 рублей в качестве штрафа!', style: AppStyle.black14,),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(children: [
                    AppElevatedButton(onTap: onAccept, text: 'Отменить заказ',height: 40),
                    const SizedBox(width: 10,),
                    AppElevatedButton(onTap: onCancel, text: 'Не отменять заказ',height: 40),
                  ],),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
