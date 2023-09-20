import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/select_time_tab.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/wishes_tab.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_images_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_snack_bar.dart';
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
        bloc.add(GoMapEvent(StartOrderMapState()));
        return false;
      },
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelStyle: AppStyle.black16,
                              indicatorColor: AppColor.firstColor,
                              indicator: UnderlineTabIndicator(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: AppColor.firstColor, width: 3)
                              ),
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
                          child: SizedBox(
                            height: size.height - 180,
                            width: size.width,
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
          ),
        ),
      ),
    );
  }
}
