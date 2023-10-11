import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../utils/size_util.dart';

class PenaltyNotificationContainer extends StatelessWidget {
  final Penalty penalty;
  final Function(Penalty penalty)? onTap;
  const PenaltyNotificationContainer( {Key? key,required this.penalty, this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap == null ? null : onTap!(penalty),
      child: Container(
        color: Colors.redAccent,
        width: size.width,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Погасите долг', style: AppStyle.black14.copyWith(color: Colors.white),),
                  Text('за поездку ${penalty.dateTime.formatDateTime()}', style: AppStyle.black12.copyWith(color: Colors.white))
                ],
                ),
              ),
              Positioned(
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Image.asset(AppImages.rightArrow, color: Colors.white,width: 10, height: 18,),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
