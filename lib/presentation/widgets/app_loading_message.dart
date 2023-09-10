import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/widgets/app_progress_container.dart';

class AppLoadingMessage {
  static Future show(BuildContext context, {bool dismissible = true}) {
   return showDialog(
        barrierColor: Colors.grey.withOpacity(0.4),
        barrierDismissible: dismissible,
        context: context, builder: (context) {
      return Center(
        child: AppProgressContainer(),
      );
    });
  }
}