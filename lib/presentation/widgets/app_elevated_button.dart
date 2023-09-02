import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/app_color_util.dart';
import '../utils/app_style_util.dart';

Widget AppElevatedButton ({String text = 'Нажать', VoidCallback? onTap, double? width, double? height, Color? textColor, Color? bgColor, bool shade = false, Gradient? gradient}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height ?? 38,
      decoration: BoxDecoration(
        gradient: gradient,
        color: bgColor ?? AppColor.firstColor,
        borderRadius: BorderRadius.circular(8),
          boxShadow: shade ? [ BoxShadow(
          color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 2
      )] : null
      ),
      child: Center(
        child: Text(
          text,
          style: AppStyle.black17.copyWith(color: textColor ?? Colors.white),
          textAlign: TextAlign.center,


        ),
      ),
    ),
  );
}