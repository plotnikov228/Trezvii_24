import 'package:flutter/material.dart';

import '../utils/app_color_util.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChange;
  const AppSwitch({Key? key, required this.value, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
        thumbColor: MaterialStateProperty.resolveWith((Set states) {
          return Colors.white;
        }),
        trackOutlineColor:  MaterialStateProperty.resolveWith((Set states) {
          if(value) return AppColor.firstColor;

          return AppColor.gray;
        }),
        activeTrackColor: AppColor.firstColor,
        inactiveTrackColor: AppColor.gray,
        value: value,
        onChanged: onChange);
  }
}
