import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/app_style_util.dart';
import '../../../../bloc/bloc/bloc.dart';
import '../../../../bloc/event/event.dart';
import '../../../../bloc/state/state.dart';

Widget driverContent () {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
        margin: const EdgeInsets.only(top: 0),
        child: const Text('Идёт инициализация заказа...', style: AppStyle.black16,),
      ),
  );
}