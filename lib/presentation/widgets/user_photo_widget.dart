import 'package:flutter/material.dart';

import '../utils/app_color_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget UserPhotoWidget(
  String url, {
  double size = 85,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      width: size, height: size,
      errorWidget: (_, __, ___) {
        return SizedBox(
          width: size / 2,
          height: size / 2,
          child: CircularProgressIndicator(
            color: AppColor.firstColor,
          ),
        );
      },
      progressIndicatorBuilder: (_, __, ___) {
        return SizedBox(
          width: size / 2,
          height: size / 2,
          child: CircularProgressIndicator(
            color: AppColor.firstColor,
          ),
        );
      },
      imageUrl: url,
    ),
  );
}
