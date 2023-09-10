import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

IconButton MenuButton (Function()? onTap) {
  return IconButton(onPressed: onTap, icon: Icon(Icons.menu, color: AppColor.firstColor, size: 25,));
}