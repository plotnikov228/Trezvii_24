import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';

import 'card.dart';

class PaymentUiModel {
  final Widget prefixWidget;
  final String title;
  final Widget suffixWidget;
  final Function? onTap;
  final PaymentTypes paymentType;
  final UserCard? card;

  PaymentUiModel(
      {required this.paymentType,
      required this.prefixWidget,
      required this.title,
      required this.suffixWidget, this.onTap, this.card,  });
}
