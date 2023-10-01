import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/settings/bloc/event.dart';
import 'package:sober_driver_analog/presentation/widgets/app_switch.dart';
import 'package:sober_driver_analog/presentation/widgets/composite_text_widget.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../ui/widgets/menu_app_bar.dart';
import 'bloc/state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final bloc= context.read<SettingsBloc>();
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppPopButton(context,
                      text: 'Настройки',
                      onTap: () => context
                          .read<MenuBloc>()
                          .add(GoMenuEvent(newState: InitialMenuState())),
                      color: Colors.black,
                      textStyle: AppStyle.black16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Wrap(
                    spacing: 18,
                    direction: Axis.vertical,
                    children: [
                      CompositeTextWidget(title: 'Город', subTitle: state.locally, width: size.width - 80,),
                      CompositeTextWidget(title: 'Язык', subTitle: state.language, width: size.width - 80,),
                      CompositeTextWidget(title: 'Геолокация', subTitle: 'Для стабильной работы приложения не отключайте определение вашего текущего местоположения', width: size.width - 80,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CompositeTextWidget(title: 'Push - уведомления', subTitle: state.pushNotificationDisabled ? 'Отключение уведомлений' : 'Включение уведомлений', width: size.width - 120,),
                          AppSwitch(value: state.pushNotificationDisabled, onChange: (val) {
                            bloc.add(ChangeNotifyDisabledSettingsEvent(push: val, email: state.emailNotificationDisabled));

                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CompositeTextWidget(title: 'Email - уведомления', subTitle: state.emailNotificationDisabled ? 'Отключение рассылки' : 'Включение рассылки', width: size.width - 120,),
                          AppSwitch(value: state.emailNotificationDisabled, onChange: (val) {
                            bloc.add(ChangeNotifyDisabledSettingsEvent(push: state.pushNotificationDisabled, email: val));
                          }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
