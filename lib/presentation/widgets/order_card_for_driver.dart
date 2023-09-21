
import 'package:flutter/material.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/extensions/order_status_extension.dart';
import 'package:sober_driver_analog/presentation/widgets/user_photo_with_border.dart';

import '../../data/firebase/auth/models/user.dart';
import '../../domain/firebase/auth/models/user_model.dart';
import '../../domain/firebase/order/model/order_with_id.dart';
import '../utils/app_color_util.dart';
import '../utils/app_style_util.dart';
import '../utils/size_util.dart';
import 'adresses_buttons.dart';

Widget OrderCardForDriver(OrderWithId order, {UserModel? user, String? userPhotoUrl, bool fullInfo = false, String? distance, String? time}) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Container(
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
                  padding: const EdgeInsets.only(top: 15),
                  child: AddressesButtons(
                    from: order.order.from,
                    to: order.order.to,
                    width: 150,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      order.order.status.descriptionForDriver(),
                      style: AppStyle.black14
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                if(user != null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        user.name,
                        style: AppStyle.black14
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                if(fullInfo)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(distance != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Text(
                              distance,
                              style: AppStyle.black12,
                            )),
                      if(time != null)
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              time,
                              style: AppStyle.black12,
                            )),
                    ],
                  )
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
                if(user != null && fullInfo)
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: userPhotoWithBorder(url: userPhotoUrl))
              ],)
          ],
        ),
      ),
    ),
  );
}
