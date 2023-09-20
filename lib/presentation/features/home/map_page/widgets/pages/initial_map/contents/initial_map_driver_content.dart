import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';

import '../../../../../../../utils/app_color_util.dart';
import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/size_util.dart';
import '../../../../../ui/widgets/address_button.dart';

class InitialMapDriverContent extends StatelessWidget {

  final Function()? onMainButtonTap;
  const InitialMapDriverContent({Key? key, this.onMainButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppElevatedButton(width: size.width - 60, text: 'Выбрать заказ', onTap: onMainButtonTap),
    );
  }
}
