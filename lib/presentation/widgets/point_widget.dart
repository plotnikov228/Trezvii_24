import 'package:flutter/cupertino.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

Widget PointWidget ({Color? color, Size? size}) {
  final _color = color ?? AppColor.firstColor;
  final _size = size ?? const Size(21, 21);
  return Container(
    width: _size.width,
    height: _size.height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(width: 2, color: _color)
    ),
    child: Center(
      child: Container(
        alignment: Alignment.center,
        width: _size.width / 2,
        height: _size.height / 2,

        decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 2, color: _color)
        ),
      ),
    ),
  );
}