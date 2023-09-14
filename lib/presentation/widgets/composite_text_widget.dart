import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../utils/app_color_util.dart';

class CompositeTextWidget extends StatelessWidget {
  final Function()? onTap;
  final Function()? onSubtitleTap;
  final double spaceBetweenTitles;
  final String title;
  final String? subTitle;
  final double? width;

  const CompositeTextWidget({super.key, this.onTap, required this.title, this.subTitle, this.width, this.onSubtitleTap, this.spaceBetweenTitles = 5});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyle.black14, overflow: TextOverflow.visible,),
            if(subTitle != null)
              SizedBox(height: spaceBetweenTitles,),
            if(subTitle != null)
              InkWell(
                  onTap: onSubtitleTap,
                  child: Text(subTitle!, style: AppStyle.black14.copyWith(color: AppColor.firstColor), overflow: TextOverflow.visible,)),

          ],
        ),
      ),
    );
  }
}
