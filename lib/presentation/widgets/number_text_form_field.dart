import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color_util.dart';
import '../utils/app_images_util.dart';
import '../utils/app_style_util.dart';
import '../utils/size_util.dart';
import 'app_text_form_field.dart';

Widget NumberTextFormField(TextEditingController controller, {String? Function(String?)? validator, required double width, double height = 49, bool hasError = false, TextInputAction textInputAction = TextInputAction.done}) {
  return AppTextFormField(controller,
      height: height,
      width: width,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      validator: validator ?? (text) {
         if(text!.trim().isEmpty) {
          return 'Заполните поле';
        }if(text!.trim().length < 10) {
           return 'Введите верный формат номера телефона';
         }

      },
      focusNode: FocusNode(),
      textInputAction: textInputAction,
      hintText: 'номер',
      prefixWidget: SizedBox(
        width: 65,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 9,
            ),
            Image.asset(
              AppImages.flag,
              width: 25,
              height: 19,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              '+7',
              style: AppStyle.black16.copyWith(color: AppColor.darkBlue),
            ),
            const SizedBox(
              width: 2,
            ),
            Container(
              width: 1,height: 65,
              color: hasError ? AppColor.firstColor : AppColor.lightGray,
            )
          ],
        ),
      ));
}
