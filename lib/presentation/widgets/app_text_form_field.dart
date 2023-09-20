import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color_util.dart';
import '../utils/app_style_util.dart';
import '../utils/size_util.dart';

Widget AppTextFormField(
  TextEditingController controller, {
  FocusNode? focusNode,
  double height = 37,
  double? width,
  Function(String)? onChanged,
  Function(String)? onSubmit,
  String hintText = 'Введите сообщение...',
  int? minLength,
  int? maxLength,
      List<TextInputFormatter>? formatters,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  Widget? prefixWidget,
      Widget? suffixWidget,
      bool autoFocus = false,
      TextInputAction textInputAction = TextInputAction.done
}) {
  return SizedBox(
    height: height,
    width: width ?? size.width - 32,
    child: TextFormField(
      inputFormatters: formatters,
      controller: controller,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      cursorColor: AppColor.firstColor,
      cursorWidth: 2,
      cursorRadius: const Radius.circular(8),
      style: AppStyle.black16,
      validator: validator,
      maxLength: maxLength,
      minLines: minLength,
      autofocus: autoFocus,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),

        hintText: hintText,
        hintStyle: AppStyle.hintText16.copyWith(fontSize: 12),
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        counterText: '',
        errorMaxLines: 2,
        errorStyle: AppStyle.black10.copyWith(color: AppColor.firstColor, fontSize: 0),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.lightGray, width: 1),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.lightGray, width: 1),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.firstColor, width: 1),
            borderRadius: BorderRadius.circular(8)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(8)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
