import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/payment/models/tariff.dart';

import '../../../../../../utils/app_color_util.dart';

class  FullTariffCard extends StatelessWidget {

  final Tariff tariff;
  final double? width;
  final double? height;
  const  FullTariffCard({super.key, required this.tariff, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.gray, width: 1)
      ),
    );
  }
}
