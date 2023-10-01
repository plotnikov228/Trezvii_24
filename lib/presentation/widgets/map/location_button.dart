import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_images_util.dart';

Widget LocationButton ({Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child:Material(
      shape:  const CircleBorder(),
      color: Colors.transparent,
      elevation: 10,
      shadowColor: Colors.black26,
      clipBehavior: Clip.antiAlias,

      child: SvgPicture.asset(AppImages.location,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
  );
}