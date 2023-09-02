import 'package:flutter/material.dart';

class AppColor {

  AppColor() {
  }

  static void initColors () {
    firstColor = yellow;
    secondColor = lightOrange;
  }

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static late Color firstColor;
  static late Color secondColor;

  static final lightGray = _fromHex('#EFEFF4');

  static final gray = _fromHex('#868686');

  static final grayForPin = _fromHex('#D8D8D8');

  static final grayForText = _fromHex('#C8C7CC');

  static final yellow = _fromHex('#F0C414');

  static final lightOrange = _fromHex('#FFB800');

  static final darkBlue = _fromHex('#242E42');

  static final turquoise = _fromHex('#4CE5B11A');

  static final darkGray = _fromHex('#9B9B9B');
  
  static final routeColor = _fromHex('#3A5DFB');

  static final iconDisableColor = _fromHex('#C0C0C0');

}