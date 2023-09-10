import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';
import 'package:sober_driver_analog/domain/payment/models/payment_ui_model.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../utils/app_color_util.dart';

Widget PaymentMethodCard(
    PaymentUiModel paymentUiModel, {Function(PaymentTypes)? onTap, double? width}) {
  return GestureDetector(
    onTap: () {
      if(onTap != null) {
        onTap(paymentUiModel.paymentType);
      }
      if(paymentUiModel.onTap != null) {
        paymentUiModel.onTap!();
      }
    },
    child: Container(
      height: 39,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.gray, width: 1)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                paymentUiModel.prefixWidget(),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  paymentUiModel.title,
                  style: AppStyle.black14.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            paymentUiModel.suffixWidget
          ],
        ),
      ),
    ),
  );
}
