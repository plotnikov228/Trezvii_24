import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

Widget menuChapter ({required String title, required Widget prefixWidget, Function()? onTap, double? width}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: width,
      height: 30,
      child:
      Row(
        children: [
          prefixWidget,
          const SizedBox(width: 20,),
          Text(title, style: AppStyle.black16,)
        ],
      ),
    ),
  );
}