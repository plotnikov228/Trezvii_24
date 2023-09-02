import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/tutorial/bloc/state.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_images_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../widgets/point_widget.dart';

Widget ChooseAdressInTutorialWidget (ChooseAddressTutorialState state, {required Size size}) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: size.width,
    color: Colors.white,
    height: 328 + 54,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 38),
          child: Center(
              child: Text(
                'Укажите адрес',
                style: AppStyle.black25,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 23),
          child: Divider(
            thickness: 1,
            color: AppColor.lightGray,
            indent: 16,
            endIndent: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 21, left: 35),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PointWidget(),
                  Image.asset(
                    AppImages.dottedLine,
                    height: 32,
                    width: 3,
                  ),
                  const Icon(
                    Icons.location_pin,
                    color: Colors.black87,
                    size: 24,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.firstAddress == null
                          ? 'Адрес'
                          : state.firstAddress!.addressName,
                      style: AppStyle.black17,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14, bottom: 14),
                      child: Divider(
                        endIndent: 16,
                        indent: 0,
                        height: 1,
                        color:
                        AppColor.lightGray.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      state.secondAddress == null
                          ? 'Адрес'
                          : state.secondAddress!.addressName,
                      style: AppStyle.black17,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 23, bottom: 12),
          child: Divider(
            thickness: 1,
            color: AppColor.lightGray,
            indent: 16,
            endIndent: 16,
          ),
        ),
      ],
    ),
  );
}