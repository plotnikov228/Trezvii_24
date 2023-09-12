import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

import '../utils/app_style_util.dart';

Widget CustomTabButton ({required String text, double? width, VoidCallback? onTap, bool isSelected = true}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 70,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(child: Text(text, style: isSelected ? AppStyle.black22.copyWith(fontSize: 18) : AppStyle.gray22.copyWith(fontSize: 18), textAlign: TextAlign.center,)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: isSelected,
              child: Container(
                width: width,
                height: 5,
                decoration: BoxDecoration(color: AppColor.firstColor,
                borderRadius: BorderRadius.circular(8)
                ),
              )
            ),
          ),
        ],
      ),
    ),
  );
}