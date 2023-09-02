import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/bloc/state.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../widgets/payment_method_card.dart';

Widget ChoosePaymentMethodInTutorialWidget (ChoosePayMethodTutorialState state, {required Size size}) {
  return Container(
    color: Colors.white,
    alignment: Alignment.bottomCenter,
    width: size.width,
    height: 405,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 25, left: 17, right: 17),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 10,
            children: state.listPayments.map((e) => PaymentMethodCard(e,
                width: size.width - 34))
                .toList(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 28),
          child: Center(
              child: Text(
                'Выберите способ оплаты',
                style: AppStyle.black25,
              )),
        ),
      ],
    ),
  );
}