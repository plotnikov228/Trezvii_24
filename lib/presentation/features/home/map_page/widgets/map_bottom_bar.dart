import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_images_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_elevated_button.dart';

Widget MapBottomBar(
    {required MapBloc bloc,
    String mainButtonText = 'Заказать',
    VoidCallback? onPaymentMethodTap,
    VoidCallback? onWishesTap,
    VoidCallback? onMainButtonTap,
    bool showTopButtons = true}) {
  return Container(
    width: size.width,
    height: 91,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, -5),
              color: Colors.black12,
              spreadRadius: 5,
              blurRadius: 5)
        ]),
    child: Padding(
      padding: const EdgeInsets.only(
        top: 7,
      ),
      child: Column(
        children: [
          Opacity(
            opacity: showTopButtons ? 1 : 0,
            child: SizedBox(
              width: size.width - 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onPaymentMethodTap,
                    child: Row(
                      children: [
                        Image(
                          image:
                              (bloc.currentPaymentModel.prefixWidget as Image)
                                  .image,
                          color: onWishesTap == null && onPaymentMethodTap != null
                              ? AppColor.iconDisableColor
                              : AppColor.firstColor,
                          width: 25,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Text(
                          bloc.currentPaymentModel.title,
                          style: AppStyle.black16,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onWishesTap,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.wishes,
                          color: onWishesTap != null && onPaymentMethodTap == null
                              ? AppColor.iconDisableColor
                              : AppColor.firstColor,
                          width: 25,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        const Text(
                          'Пожелания',
                          style: AppStyle.black16,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AppElevatedButton(
                width: size.width - 60,
                height: 38,
                text: mainButtonText,
                onTap: onMainButtonTap),
          )
        ],
      ),
    ),
  );
}
