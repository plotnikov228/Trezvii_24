import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_with_id.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/extensions/order_status_extension.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/adresses_buttons.dart';
import 'package:sober_driver_analog/presentation/widgets/user_photo_with_border.dart';

import '../../data/firebase/auth/models/driver.dart';
import '../utils/size_util.dart';

Widget FullOrderCardWidget(OrderWithId order, {String? submissionTime, Driver? driver}) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Container(
      height: 263,
      width: size.width - 60,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.firstColor, width: 1),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '№${order.id}\n${order.order.startTime.formatDateTime()}',
                  style: AppStyle.black12.copyWith(fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: AddressesButtons(
                    from: order.order.from,
                    to: order.order.to,
                    width: 150,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      order.order.status.description(),
                      style: AppStyle.black14
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                if(driver != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      driver!.name,
                      style: AppStyle.black14
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                if(order.order.status is WaitingForOrderAcceptanceOrderStatus && submissionTime != null)
                Text('Время подачи ~ $submissionTime', style: AppStyle.black14,)
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    '~ ${order.order.costInRub} р.',
                    style: AppStyle.black16,
                  )),
              if(driver != null)
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: userPhotoWithBorder(url: driver.personalDataOfTheDriver.driverPhotoUrl))
            ],)
          ],
        ),
      ),
    ),
  );
}
