import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

import '../../../../utils/app_style_util.dart';

Widget OrdersCountWidget ({required int ordersQuantity, Function? onTap}) {
  return InkWell(
    onTap: () {
      if(onTap != null) onTap!();
      print('tap');
    },
    child: Container(
      width: 130,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor.firstColor, width: 1)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Мои заказы', style: AppStyle.black14,),
          SizedBox(width: 4,),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.firstColor
              ),
              child: Center(
                child: Text('$ordersQuantity', style: AppStyle.black14.copyWith(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    ),
  );
}