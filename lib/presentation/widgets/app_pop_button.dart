import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_images_util.dart';
import '../utils/app_style_util.dart';

Widget AppPopButton(BuildContext context,
    {required String text, required Color color, Function? onTap}) {
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
                width: 12,
                height: 20,
                color: color,
              )),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Text(
              text,
              style: AppStyle.black22.copyWith(color: color),
            ),
          )
        ],
      ),
    ),
  );
}
