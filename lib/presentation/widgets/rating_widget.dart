import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_images_util.dart';
import '../utils/app_style_util.dart';

Widget ratingWidget (String rating) {
  return Row(
    children: [
      SvgPicture.asset(AppImages.star),
      const SizedBox(
        width: 4,
      ),
      Text(
        rating,
        style: AppStyle.black14
            .copyWith(fontWeight: FontWeight.w400),
      ),
    ],
  );
}