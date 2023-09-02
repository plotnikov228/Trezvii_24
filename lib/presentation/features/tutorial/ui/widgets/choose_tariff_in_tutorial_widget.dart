import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/bloc/state.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../widgets/tariff_card.dart';
import '../../bloc/event.dart';

Widget ChooseTariffInTutorialWidget (ChooseTariffTutorialState state, {required Size size, required TutorialBloc bloc}) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: size.width,
    height: 269,
    color: Colors.white,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 25),
          child: Center(
              child: Text(
                'Выберите тарифный план',
                style: AppStyle.black25,
              )),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 31, bottom: 11),
            child: SizedBox(
              height: 62,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.tariffList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: TariffCard(
                          state.tariffList![index],
                          selected: index ==
                              state.selectedTariffIndex,
                          onTap: () => bloc.add(
                              ChooseTariffTutorialEvent(
                                  index))),
                    );
                  }),
            )),
      ],
    ),
  );
}