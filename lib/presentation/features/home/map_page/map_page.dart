import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/features/home/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/active_orders_page.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/add_card_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/add_wishes_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/cancelled_order_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/check_bonuses_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/create_order_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/initial_map_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/promo_code_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/select_address_widget.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/select_payment_method_page.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/waiting_for_order_acceptence.dart';
import 'package:sober_driver_analog/presentation/widgets/map/map_widget.dart';

import '../../../utils/app_color_util.dart';
import '../../../utils/size_util.dart';
import '../../../utils/status_enum.dart';
import '../../../widgets/app_snack_bar.dart';
import '../bloc/event.dart';
import '../ui/widgets/menu_button.dart';
import 'widgets/orders_count_widget.dart';
import 'widgets/pages/add_price_page.dart';
import 'widgets/pages/order_accepted_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
        listener: (context, cur) {
            context.pop();
          if (cur.exception != null && cur.message != null) {
            AppSnackBar.showSnackBar(context,
                content: cur.exception ?? cur.message!);
          }
          else if (cur.status == Status.Loading) {
            showDialog(
              barrierDismissible: false,
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.firstColor,
                        ),
                      ),
                    ),
                  );
                });
          }
        },
        listenWhen: (prev, cur) =>
            (cur.message != null || cur.status != Status.Success) || (prev.message != null || prev.status != Status.Success),
        builder: (context, state) {
          final bloc = context.read<MapBloc>();
          return Stack(
            children: [
              MapWidget(
                drivingRoute: bloc.currentRoute,
                size: Size(
                    size.width,
                    state is ActiveOrderMapState
                        ? size.height
                        : state is WaitingForOrderAcceptanceMapState ? size.height - 146 : size.height - 160),
                getCameraPosition: (_) {
                  bloc.setCameraPosition(_);
                },
                firstPlacemark: bloc.fromAddress?.appLatLong,
                secondPlacemark: bloc.toAddress?.appLatLong,
                getAddress: (_) {
                  if (bloc.getAddressFromMap) {
                    bloc.fromAddress = _;
                    bloc.firstAddressController.text = _.addressName;
                    bloc.add(GoMapEvent(bloc.state));
                  }
                },
                initialCameraPosition: bloc.cameraPosition,
              ),

              IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(height: 100,
                  width: size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white, Colors.white12]
                      )
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48,left: 8),
                  child: MenuButton(() => context.read<HomeBloc>().add(GoToMenuHomeEvent())),
                ),
              ),

              Visibility(
                visible: bloc.activeOrders.isNotEmpty,
                child: Align(alignment: Alignment.topRight,
                child: Padding(padding: const EdgeInsets.only(top: 48,right: 20),
                    child: OrdersCountWidget(ordersQuantity: bloc.activeOrders.length,                      onTap: () => bloc.add(GoMapEvent(ActiveOrdersMapState())),

                    ),
                    ),),

              ),
              if (state is InitialMapState)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: InitialMapWidget(
                      state: state,
                      bloc: bloc,
                    )),
              if (state is SelectAddressesMapState)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SelectAddressWidget(bloc: bloc, state: state)),
              if (state is CreateOrderMapState)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CreateOrderWidget(
                    bloc: bloc,
                    state: state,
                  ),
                ),
              if (state is CancelledOrderMapState)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CanceledOrderWidget(
                    bloc: bloc,
                    state: state,
                  ),
                ),
              if (state is CheckBonusesMapState)
                CheckBonusesWidget(
                  bloc: bloc,
                  state: state,
                ),
              if (state is PromoCodeMapState)
                PromoCodeWidget(
                  bloc: bloc,
                  state: state,
                ),
              if (state is AddWishesMapState)
                AddWishesWidget(
                  bloc: bloc,
                  state: state,
                ),
              if (state is SelectPaymentMethodMapState)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SelectPaymentMethodWidget(bloc: bloc, state: state)),
              if (state is WaitingForOrderAcceptanceMapState)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: WaitingForOrderAcceptanceWidget(state: state, bloc: bloc)),
              if (state is OrderAcceptedMapState)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: OrderAcceptedWidget(
                    state: state,
                    bloc: bloc,
                  ),
                ),
              if(state is AddCardMapState)
                AddCardWidget(bloc: bloc, state: state),
              if(state is ActiveOrdersMapState)
                ActiveOrdersPage(bloc: bloc, state: state),
              if(state is AddPriceMapState)
                AddPricePage(bloc: bloc, state: state),
            ],
          );
        });
  }
}
