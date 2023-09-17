import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/ui/widgets/menu_app_bar.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_pop_button.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/full_order_card_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                menuAppBar(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: AppPopButton(context,
                            onTap: () => context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState())),
                            text: 'История заказов', color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 42,
                        width: size.width - 20,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        child: TabBar(
                          indicatorWeight: 0,
                          indicatorSize: TabBarIndicatorSize.tab,
                            tabs: const [
                              Tab(
                                text: 'Завершённые',
                                height: 42,
                              ),
                              Tab(
                                text: 'Отменённые',
                                height: 42,
                              )
                            ],
                            labelStyle: AppStyle.black16,
                            unselectedLabelColor: AppColor.textTabColor,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: null,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    height: size.height - 250,
                    width: size.width,
                    child: TabBarView(
                      children: [
                        SizedBox(
                          height: size.height - 250,
                          width: size.width,
                          child: state.completedOrders.isEmpty ? Center(child: Text('Нет заказов', style: AppStyle.black22.copyWith(color: AppColor.firstColor),),) : ListView(
                            children: List.generate(
                                state.completedOrders.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FullOrderCardWidget(
                                      state.completedOrders[index],
                                      driver: state.completedOrderDrivers[index]),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: size.height - 250,
                          width: size.width,
                          child:state.cancelledOrders.isEmpty ? Center(child: Text('Нет заказов', style: AppStyle.black22.copyWith(color: AppColor.firstColor),),) : ListView(
                            children: List.generate(
                                state.cancelledOrders.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FullOrderCardWidget(
                                      state.cancelledOrders[index],
                                      driver: state.cancelledOrderDrivers[index]),
                                )),
                          ),
                        ),
                      ],
                    ),
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
