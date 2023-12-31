import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

Widget AddressButton ({AddressModel? addressModel,required double width, Function()? onTap, Widget? prefixIcon, String hintText = 'Куда?', bool showAddressName = true}) {
  final text = addressModel?.addressName ?? hintText;
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 45,
      width: width,
      child: Row(
        children: [
          if(prefixIcon != null)
          prefixIcon,
          const SizedBox(width: 10,),
          Flexible(
              fit: FlexFit.loose,
              child: Text(showAddressName ? addressModel?.name ?? text : text, style: addressModel == null ? AppStyle.hintText16.copyWith(fontSize: 14) : AppStyle.black14, overflow: TextOverflow.ellipsis, maxLines: 2,)),
        ],
      )
    ),
  );
}