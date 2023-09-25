import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/route_card_widget.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/state/state.dart';

class ActiveOrderWidget extends StatelessWidget {
  const ActiveOrderWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Container(
      height: 165,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 40, right:  40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            routeCardWidget(bloc.routeStream!, from: bloc.fromAddress, to: bloc.toAddress),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {
                  // списывание какой то суммы за ложный вызов
                }, icon: SvgPicture.asset(AppImages.close)),
                IconButton(onPressed: () {
                  //some func

                }, icon: SvgPicture.asset(AppImages.call)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
