import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/app_style_util.dart';
import '../../../../bloc/bloc/bloc.dart';
import '../../../../bloc/event/event.dart';
import '../../../../bloc/state/state.dart';

Widget userContent (MapBloc bloc) {
  return Column(
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

          }, icon: const Icon(Icons.close, color:  Colors.deepPurple, size: 30,)),
          IconButton(onPressed: () {
            //some func

          }, icon: SvgPicture.asset(AppImages.call)),
          IconButton(onPressed: () {
            bloc.add(GoMapEvent(AddPriceMapState()));

          }, icon: SvgPicture.asset(AppImages.wait))
        ],
      )
    ],
  );
}