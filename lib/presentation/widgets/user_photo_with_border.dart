import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget userPhotoWithBorder({String? url, File? file, double size = 100, Function()? onTap}) {
  return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(44),
          border: Border.all(color: Colors.white),color: Colors.white,
        ),

        child:ClipRRect(
  borderRadius: BorderRadius.circular(44),
  child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: Colors.grey.withOpacity(0.4),
              size: 45,
            ),
            if (url != null)

                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: size - 5,
                    height: size - 5,
                    color: Colors.white,
                  ),
                  width: size - 5,
                  height: size - 5,
                ),
            if (file != null)
              Image.file(
                file,
                fit: BoxFit.cover,
                width: size - 5,
                height: size - 5,
              )
          ],
        ),
      ),
    ),
  );
}
