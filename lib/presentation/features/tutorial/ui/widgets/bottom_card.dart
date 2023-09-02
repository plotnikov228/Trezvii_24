import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../utils/size_util.dart';
import '../../../../widgets/app_elevated_button.dart';

Widget BottomCard(
    {VoidCallback? onTap,
    int indicatorPosition = 0,
    required int indicatorLength}) {
  const double _lengthDivision = 30;
  double _leftPadding = _lengthDivision * indicatorPosition;
  return Align(

    alignment: Alignment.bottomCenter,
    child: Container(
      width: size.width - 4,
      height: 104,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0, -5),
                spreadRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppElevatedButton(
              onTap: onTap,
              text: 'ПРОПУСТИТЬ',
              width: 190,
              height: 45

            ),
          ),
          Padding(padding: EdgeInsets.only(top: 16),
          child: Stack(
            children: [
              Container(
                width: _lengthDivision * indicatorLength,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20)
                ),),
              Padding(
                padding: EdgeInsets.only(left: _leftPadding),
                child: Container(
                    alignment: Alignment.centerLeft,
                    width: _lengthDivision,
                    height: 6,
                    decoration: BoxDecoration(
                        color: AppColor.firstColor,
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
            ],
          ),)
        ],
      ),
    ),
  );
}
