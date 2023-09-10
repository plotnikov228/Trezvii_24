import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_images_util.dart';
import '../utils/app_style_util.dart';

Widget AppPopButton(BuildContext context,
    {required String text, required Color color, Function? onTap, double iconWidth = 12, double iconHeight = 20, TextStyle? textStyle}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 16),
    child: InkWell(
      onTap: () {
        if (onTap != null)
          onTap();
        else {
          context.pop();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.rotate(
              angle: pi,
              child: Image.asset(
                AppImages.rightArrow,
                width: iconWidth,
                height: iconHeight,
                color: color,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Text(
              text,
              style: textStyle ?? AppStyle.black22.copyWith(color: color),
            ),
          )
        ],
      ),
    ),
  );
}
