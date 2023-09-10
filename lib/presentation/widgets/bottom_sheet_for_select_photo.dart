import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_color_util.dart';
import '../utils/app_images_util.dart';
import '../utils/app_style_util.dart';
import '../utils/size_util.dart';

class BottomSheetForSelectPhoto extends StatelessWidget {
  final Function()? onCameraTap;
  final Function()? onGalleryTap;
  const BottomSheetForSelectPhoto({Key? key, this.onCameraTap, this.onGalleryTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
      size.height /
          3,
      width: size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(
                    0,
                    5),
                color: Colors
                    .black
                    .withOpacity(
                    0.2),
                spreadRadius:
                1,
                blurRadius:
                10)
          ],
          color: Colors
              .white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius
                  .circular(
                  8),
              topRight:
              Radius.circular(
                  8))),
      child: Center(
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceEvenly,
          children: [
            InkWell(
              onTap: onGalleryTap,
              child:
              SizedBox(
                height: size.width /
                    2.5,
                width: size.width /
                    2.5,
                child:
                Card(
                  color:
                  Colors.white,
                  surfaceTintColor:
                  Colors.white,
                  child:
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.gallery,
                          color: AppColor.firstColor,
                          width: size.width / 6,
                          height: size.width / 6,
                        ),
                        const Text(
                          'Выбрать из галереи',
                          style: AppStyle.black16,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onCameraTap,
              child:
              SizedBox(
                height: size.width /
                    2.5,
                width: size.width /
                    2.5,
                child:
                Card(
                  color:
                  Colors.white,
                  surfaceTintColor:
                  Colors.white,
                  child:
                  Padding(
                    padding:
                    const EdgeInsets.all(8.0),
                    child:
                    Column(
                      children: [
                        SvgPicture.asset(
                          AppImages.camera,
                          color: AppColor.firstColor,
                          width: size.width / 6,
                          height: size.width / 6,
                        ),
                        const Text(
                          'Сделать снимок',
                          style: AppStyle.black16,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
