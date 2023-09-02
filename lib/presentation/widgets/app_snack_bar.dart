import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

class AppSnackBar {
  static void showSnackBar(BuildContext context,
      {required String content, bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      content,
      style: isError
          ? AppStyle.black14.copyWith(color: Colors.red)
          : AppStyle.black14,
    ),
    backgroundColor: AppColor.firstColor,
    ));
  }
}
