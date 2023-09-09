import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/widgets/point_widget.dart';

import '../features/home/ui/widgets/address_button.dart';
import '../utils/app_color_util.dart';
import '../utils/app_images_util.dart';
import '../utils/size_util.dart';

class AddressesButtons extends StatelessWidget {
  final VoidCallback? onFromTap;
  final AddressModel? from;
  final VoidCallback? onToTap;
  final AddressModel? to;
  final double? width;
  const AddressesButtons({super.key, this.onFromTap, this.from, this.onToTap, this.to, this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.dottedLine,
                height: 32,
                width: 3,
              ),
              Center(
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 16),
                  child: Container(
                    width: width != null ? width! - 30 : size.width - 100,
                    height: 1,
                    decoration: BoxDecoration(
                        color: AppColor.lightGray
                            .withOpacity(0.5),
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(8))),
                  ),
                ),
              )
            ],
          ),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressButton(
                addressModel:from,

                prefixIcon: PointWidget(),
                width: width ??  size.width - 70,
                onTap: onFromTap
              ),
              const SizedBox(
                height: 27,
              ),
              AddressButton(
                addressModel: to,
                prefixIcon: const Icon(
                  Icons.location_pin,
                  color: Colors.black87,
                  size: 24,
                ),
                width: width ??size.width - 70,
                onTap: onToTap
              )
            ]),
      ],
    );
  }
}
