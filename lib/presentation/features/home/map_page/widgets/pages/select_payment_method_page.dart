import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/payment_method_card.dart';

import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_snack_bar.dart';
import '../../bloc/event/event.dart';
import '../map_bottom_bar.dart';

class SelectPaymentMethodWidget extends StatelessWidget {
  final MapBloc bloc;
  final SelectPaymentMethodMapState state;

  const SelectPaymentMethodWidget(
      {super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(StartOrderMapState()));
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
                  child: Center(
                    child: Text(
                      'Способ оплаты',
                      style: AppStyle.black17,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 11,
                      children: state.methods.isEmpty
                          ? []
                          : state.methods
                              .toList()
                              .map((e) => PaymentMethodCard(

                          e,
                          width: size.width - 40,
                          onTap: (type) {
                                    bloc.add(OnPaymentTapMapEvent(context, e));
                                  }))
                              .toList(),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MapBottomBar(
                  mainButtonActive: bloc.orderInCompanyRange,
                  mainButtonText: bloc.orderInCompanyRange ? 'Заказать' : 'Неверный маршрут',
                  suffixWidget: bloc.orderInCompanyRange ? null : IconButton(onPressed: () {
                    AppSnackBar.showSnackBar(context, content: 'Выбранный маршрут вне зоны покрытия компании: ${bloc.localities}');
                  }, icon: const Icon(Icons.info, color: Colors.white,)),
                  bloc: bloc, onMainButtonTap: () {
                    if(bloc.orderInCompanyRange) {
                      if (bloc.fromAddress == null || bloc.toAddress == null) {
                        AppSnackBar.showSnackBar(
                            context, content: 'Выберите маршрут поездки');
                      } else {
                        bloc.add(CreateOrderMapEvent());
                      }
                    }
              },
                  onWishesTap: () => bloc.add(GoMapEvent(AddWishesMapState()))
              ),
            )
          ],
        ),
      ),
    );
  }
}
