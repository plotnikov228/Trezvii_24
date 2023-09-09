import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

Widget AddressButton ({AddressModel? addressModel,required double width, Function()? onTap, Widget? prefixIcon, String hintText = 'Куда?'}) {

  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 24,
      width: width,
      child: Row(
        children: [
          if(prefixIcon != null)
          prefixIcon,
          SizedBox(width: 10,),
          Flexible(
            fit: FlexFit.loose,
            child: Text(addressModel?.addressName ?? hintText, style: addressModel == null ? AppStyle.hintText16 : AppStyle.black16, overflow: TextOverflow.ellipsis,),
          ),
        ],
      )
    ),
  );
}