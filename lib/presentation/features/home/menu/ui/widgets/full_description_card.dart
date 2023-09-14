import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/news/models/news_model.dart';
import 'package:sober_driver_analog/domain/payment/models/tariff.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../utils/app_color_util.dart';

class  FullDescriptionCard extends StatelessWidget {

  final double? width;
  final String title;
  final String content;
  final String badgeLabel;
  const  FullDescriptionCard({super.key, this.width, required this.title, required this.content, required this.badgeLabel,});

  @override
  Widget build(BuildContext context) {
    return CustomBadge(
      label: Text(badgeLabel, style: AppStyle.black15,),
      backgroundColor: AppColor.firstColor,
      isVisible: true,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.gray, width: 1),
        ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.black16.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.visible,),
                const SizedBox(height: 30,),
                Text(content, style: AppStyle.black16, overflow: TextOverflow.visible,),

              ],
        ),
          ),
      ),
    );
  }
}
class CustomBadge extends StatelessWidget {
  final Widget? label;
  final Widget child;
  final bool isVisible;
  final Color backgroundColor;

  CustomBadge({this.label, required this.child, required this.isVisible, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: <Widget>[
        child,
        Visibility(
          visible: isVisible,
          child: Positioned(
            right: 0,
            bottom: -5,
            child: Container(
              decoration: BoxDecoration(
borderRadius: BorderRadius.circular(50),                color: backgroundColor,
              ),                  padding: const EdgeInsets.symmetric(horizontal: 10),

              child: label!,

              ),
            ),
          ),

      ],
    );
  }
}

