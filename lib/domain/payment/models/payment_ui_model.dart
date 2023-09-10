import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';

import '../../../presentation/utils/app_color_util.dart';
import 'card.dart';

class PaymentUiModel {
  final String prefixWidgetAsset;
  final String title;
  final Widget suffixWidget;
  final Function? onTap;
  final PaymentTypes paymentType;
  final UserCard? card;

  PaymentUiModel(
      {required this.paymentType,
      required this.prefixWidgetAsset,
      required this.title,
      required this.suffixWidget, this.onTap, this.card,  });

  Widget prefixWidget () {
    return SvgPicture.asset(
      prefixWidgetAsset,
      color: AppColor.firstColor,
      width: 25,
      height: 25,
    );
  }
}
