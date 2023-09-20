import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/payment_method_card.dart';

import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_snack_bar.dart';
import '../../bloc/event/event.dart';
import '../map_bottom_bar.dart';

class PromoCodeWidget extends StatelessWidget {
  final MapBloc bloc;
  final PromoCodeMapState state;

  const PromoCodeWidget(
      {super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(SelectPaymentMethodMapState()));
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
                    'Промокоды',
                    style: AppStyle.black17,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(child: AppTextFormField(state.controller!,
                    prefixWidget:  Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SvgPicture.asset(AppImages.discount, width: 30, height: 30,),
                    )
                    ))
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: MapBottomBar(bloc: bloc,
                  mainButtonText: 'Готово',
                  onMainButtonTap: () {
                    bloc.add(CheckPromoMapEvent());
                  },
                  showTopButtons: false,
                )
            ),

          ],
        ),
      ),
    );
  }
}
