import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_check_box.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/payment_method_card.dart';

import '../../../../../../utils/app_color_util.dart';
import '../../../../../../utils/size_util.dart';
import '../../../../../../widgets/app_snack_bar.dart';
import '../../bloc/event/event.dart';
import '../map_bottom_bar.dart';

class AddCardWidget extends StatelessWidget {
  final MapBloc bloc;
  final AddCardMapState state;

  AddCardWidget({super.key, required this.bloc, required this.state});

  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(SelectPaymentMethodMapState()));
        return false;
      },
      child: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'Добавить карту',
                  style: AppStyle.black17,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Row(
                    children: [
                      AppCheckBox(
                          width: size.width - 40,
                          iconSize: 25,
                          value: checkBox,
                          onChange: (val) {

                            checkBox = val;
                            bloc.add(GoMapEvent(AddCardMapState()));
                          })
                    ],
                  )),
              Padding(padding: EdgeInsets.only(left: 60),
              child: TextButton(onPressed: () {
                // go to browser
              },
              child: Text('Пользовательское соглашение', style: AppStyle.black15.copyWith(color: AppColor.firstColor)),),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: AppElevatedButton(
                width: size.width - 40,
                text: 'Продолжить',
                onTap: () => bloc.add(AddCardMapEvent())),
          )
        ],
      ),
    );
  }
}
