import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../utils/app_color_util.dart';
import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/size_util.dart';
import '../../../../../ui/widgets/address_button.dart';

class InitialMapUserContent extends StatelessWidget {
  final InitialMapState state;

  final Function()? onAddressButtonTap;
  final Function()? onFavoriteAddressButtonTap;
  final Function()? onArrowTap;
  const InitialMapUserContent({Key? key, this.onAddressButtonTap, this.onFavoriteAddressButtonTap, this.onArrowTap, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AddressButton(
                onTap: onAddressButtonTap,
                width: size.width - 80,
                prefixIcon: const Icon(
                  Icons.location_pin,
                  color: Colors.black87,
                  size: 24,
                )),
            GestureDetector(
                onTap: onArrowTap,
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                        child: Image.asset(
                          AppImages.rightArrow,
                          height: 22,
                          width: 12,
                        ))))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AddressButton(
              addressModel: state.lastFavoriteAddress,
              onTap: onFavoriteAddressButtonTap,
              width: size.width - 80,
              hintText: 'Избранные адреса',
              prefixIcon: Icon(
                Icons.favorite,
                color: AppColor.firstColor,
                size: 24,
              )),
        )
      ],
    );
  }
}
