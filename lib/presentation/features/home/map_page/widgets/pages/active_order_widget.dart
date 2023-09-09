import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/state/state.dart';

class ActiveOrderWidget extends StatelessWidget {
  final ActiveOrderMapState state;
  final MapBloc bloc;
  const ActiveOrderWidget({super.key, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 40, right:  40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Text('Заказ принят, идёт поиск водителя', style: AppStyle.black16,),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  bloc.add(CancelSearchMapEvent());

                }, icon: SvgPicture.asset(AppImages.close)),
                IconButton(onPressed: () {
                  //some func

                }, icon: SvgPicture.asset(AppImages.call)),
                IconButton(onPressed: () {
                  //some func

                }, icon: SvgPicture.asset(AppImages.wait))
              ],
            )
          ],
        ),
      ),
    );
  }
}
