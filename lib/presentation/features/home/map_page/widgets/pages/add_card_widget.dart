import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_check_box.dart';
import '../../../../../widgets/app_elevated_button.dart';
import '../../bloc/event/event.dart';

class AddCardWidget extends StatefulWidget {
  final MapBloc bloc;
  final AddCardMapState state;
  const AddCardWidget( {super.key, required this.bloc, required this.state,});

  @override
  State<AddCardWidget> createState() => _AddCardWidgetState();
}

class _AddCardWidgetState extends State<AddCardWidget> {

  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.bloc.add(GoMapEvent(SelectPaymentMethodMapState()));
        return false;
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
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
                    padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
                    child: AppCheckBox(
                        width: size.width - 40,
                        iconSize: 25,
                        text: 'Я согласен с условиями работы платежного сервиса',
                        value: checkBox,
                        onChange: (val) {

                          checkBox = !checkBox;
setState(() {

});                            })),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: TextButton(onPressed: () {
                      // go to browser
                    },
                      child: Text('Пользовательское соглашение', style: AppStyle.black15.copyWith(color: AppColor.firstColor)),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: AppElevatedButton(
                      width: size.width - 40,
                      text: 'Продолжить',
                      onTap: () => widget.bloc.add(AddCardMapEvent())),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
