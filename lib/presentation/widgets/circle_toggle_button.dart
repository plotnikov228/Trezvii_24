import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color_util.dart';

Widget circleToggleButton({bool value = false, Function(bool)? onChange, double size = 25}) {
  return InkWell(
    onTap: () {if(onChange != null) onChange(!value);},
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: value? AppColor.darkGray : AppColor.firstColor, width: 2),

      ),
      child: value ? Center(
        child: Container(
          width: size - 10,
          height: size - 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.firstColor
          ),
        ),
      ) : null,
    ),
  );
}