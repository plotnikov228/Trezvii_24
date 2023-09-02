import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/widgets/pages/select_time_tab.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/widgets/pages/wishes_tab.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_check_box.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/number_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/payment_method_card.dart';

import '../../../../../../utils/app_color_util.dart';
import '../../../../../../utils/app_images_util.dart';
import '../../../../../../utils/size_util.dart';
import '../../../../../../widgets/app_snack_bar.dart';
import '../../bloc/event/event.dart';
import '../map_bottom_bar.dart';

class AddWishesWidget extends StatelessWidget {
  final MapBloc bloc;
  final AddWishesMapState state;

  const AddWishesWidget({super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(CreateOrderMapState()));
        return false;
      },
      child: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelStyle: AppStyle.black16,
                        indicatorColor: AppColor.firstColor,
                        labelStyle: AppStyle.black16,
                        tabs: const [
                          Tab(
                            text: 'Пожелания',
                          ),
                          Tab(
                            text: 'Время',
                          )
                        ])),
                Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Expanded(
                      child: TabBarView(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: wishesTab(context, bloc, state),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SelectTimeTab(bloc: bloc, state: state),
                        )
                      ]),
                    )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MapBottomBar(
              bloc: bloc,
              onMainButtonTap: () {
                if (bloc.fromAddress == null || bloc.toAddress == null) {
                  AppSnackBar.showSnackBar(context,
                      content: 'Выберите маршрут поездки');
                } else {
                  bloc.add(CreateOrderMapEvent());
                }
              },
              onPaymentMethodTap: () =>
                  bloc.add(GoMapEvent(SelectPaymentMethodMapState())),
            ),
          )
        ],
      ),
    );
  }
}
