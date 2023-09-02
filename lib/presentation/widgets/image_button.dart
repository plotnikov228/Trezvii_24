import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget ImageButton({
  File? file,
  String? url,
  String? asset,
  String? svgAsset,
  Function()? onTap,
  double? width,
  double? height,
  BoxShape? shape,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width ?? 200,
      height: height ?? 100,
      decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          color: Colors.grey.withOpacity(0.4)),
      child: ClipRRect(
        borderRadius: (shape ?? BoxShape.rectangle) == BoxShape.rectangle ? BorderRadius.circular(0) : BorderRadius.circular(100),
        child: file != null
            ? Image.file(file, fit: BoxFit.cover,)
            : url != null
                ? Image.network(url, fit: BoxFit.cover)
                : asset != null
                    ? Image.asset(asset, fit: BoxFit.cover)
                    : svgAsset != null
                        ? SvgPicture.asset(svgAsset, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
      ),
    ),
  );
}
