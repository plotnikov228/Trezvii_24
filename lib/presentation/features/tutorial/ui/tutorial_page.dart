import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/ui/widgets/choose_adress_in_tutorial_widget.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/ui/widgets/choose_paymenth_method_in_tutorial_widget.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/ui/widgets/choose_tariff_in_tutorial_widget.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/payment_method_card.dart';
import 'package:sober_driver_analog/presentation/widgets/point_widget.dart';
import 'package:sober_driver_analog/presentation/widgets/tariff_card.dart';

import '../../../utils/app_color_util.dart';
import '../../../utils/app_images_util.dart';
import '../../../utils/size_util.dart';
import '../../../widgets/map/map_widget.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import 'widgets/bottom_card.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:BlocProvider(
      create: (BuildContext context) =>
      TutorialBloc(ChooseAddressTutorialState())
        ..add(InitializeTutorialEvent()),
      child:  BlocBuilder<TutorialBloc, TutorialState>(
          builder: (BuildContext context, state) {
            final bloc = context.read<TutorialBloc>();
            return Stack(
              children: [
                MapWidget(
                  size: Size(size.width, size.height - 269),
                  getAddress: (address) {
                    print(address.addressName);
                    bloc.add(ChooseAddressTutorialEvent(address));
                  },
                ),
                Align(alignment: Alignment.bottomCenter,
                child: state is ChooseAddressTutorialState
                    ? ChooseAdressInTutorialWidget(state, size: size)
                    : state is ChooseTariffTutorialState
                    ? ChooseTariffInTutorialWidget(
                    state, size: size, bloc: bloc)
                    : ChoosePaymentMethodInTutorialWidget(
                    (state as ChoosePayMethodTutorialState), size: size),
                ),

                BottomCard(
                    indicatorLength: bloc.states.length,
                    onTap: () =>
                        bloc.add(
                          SkipTutorialEvent(context),
                        ),
                    indicatorPosition: bloc.currentStateIndex)
              ],
            );

            return Container();
          },
        ),
      ),
    );
  }
}
