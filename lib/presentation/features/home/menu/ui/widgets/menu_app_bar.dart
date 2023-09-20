import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/size_util.dart';

Widget menuAppBar ({required Widget child, EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 25)}) {
  return Container(
    height: 162,
    width: size.width,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColor.firstColor,
          AppColor.firstColor,
          Colors.white10
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    child: Padding(
      padding: padding,
      child: child
    ),
  );
}