import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

class AppCheckBox extends StatelessWidget {
  AppCheckBox(
      {this.fontStyle,
        this.alignment,
        this.isRightCheck = false,
        this.iconSize,
        this.value,
        this.onChange,
        this.text,
        required this.width,
        this.margin, this.onTapOnText});

  TextStyle? fontStyle;

  Alignment? alignment;

  bool? isRightCheck;

  double? iconSize;

  bool? value;

  Function(bool)? onChange;

  VoidCallback? onTapOnText;

  String? text;

  double width;

  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: _buildCheckboxWidget(),
    )
        : _buildCheckboxWidget();
  }

  _buildCheckboxWidget() {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.zero,
      child: isRightCheck! ? getRightSideCheckbox() : getLeftSideCheckbox(),
    );
  }

  Widget getRightSideCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: getTextWidget(),
        ),
        getCheckboxWidget(),
      ],
    );
  }

  Widget getLeftSideCheckbox() {
    return Row(
      children: [
        getCheckboxWidget(),
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
          ),
          child: getTextWidget(),
        ),
      ],
    );
  }

  Widget getTextWidget() {
    return InkWell(
      onTap: onTapOnText,
      child: SizedBox(
        width: width - 8 - (iconSize ?? 25),
        child: Text(
          text ?? "",
          style: fontStyle,
        ),
      ),
    );
  }

  Widget getCheckboxWidget() {
    return Container(
      height: iconSize,
      width: iconSize,
      decoration: BoxDecoration(
        color: AppColor.firstColor,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Checkbox(
        value: value ?? false,
        onChanged: (value) {
          onChange!(value!);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        checkColor: Colors.white,
        activeColor: AppColor.firstColor,
        fillColor: MaterialStatePropertyAll(AppColor.firstColor),
        overlayColor: MaterialStatePropertyAll(AppColor.firstColor),
        focusColor: AppColor.firstColor,

        hoverColor: AppColor.firstColor,
        side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(
              color: AppColor.firstColor
          ),
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
    );
  }
}

