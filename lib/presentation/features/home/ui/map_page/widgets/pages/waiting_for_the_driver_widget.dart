import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_duration_between_two_points.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../../../data/map/repository/repository.dart';
import '../../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/state/state.dart';

class WaitingForTheDriverWidget extends StatelessWidget {
  final OrderAcceptedMapState state;
  final MapBloc bloc;

  const WaitingForTheDriverWidget(
      {super.key, required this.state, required this.bloc});

  String calculateTimeBetweenDates() {
    Duration duration = state.waitingTime!;

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String result = '';

    if (days > 0) {
      result += '$days день ';
    }

    if (hours > 0) {
      result += '$hours часов ';
    }

    if (minutes > 0) {
      result += '$minutes минут';
    }

    return result.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 292,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: Text(
                'Время подачи - ${calculateTimeBetweenDates()}',
                style: AppStyle.black16,
              ),
            ),
            Container(
              width: size.width - 80,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Flexible(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(
                              'Ожидайте водителя',
                              style: AppStyle.black14
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              state.driver!.name,
                              style: AppStyle.black14
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.star),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  state.driver!.getRating(),
                                  style: AppStyle.black14
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  state.distance!,
                                  style: AppStyle.black14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.gray),
                                ),
                              ],
                            )
                          ],
                        )),
                    Flexible(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        state.driver!.personalDataOfTheDriver.driverPhotoUrl,
                        fit: BoxFit.scaleDown,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      bloc.add(CancelSearchMapEvent());
                    },
                    icon: SvgPicture.asset(AppImages.close)),
                IconButton(
                    onPressed: () {
                      //some func
                    },
                    icon: SvgPicture.asset(AppImages.call)),
                IconButton(
                    onPressed: () {
                      //some func
                    },
                    icon: SvgPicture.asset(AppImages.chatRoom))
              ],
            )
          ],
        ),
      ),
    );
  }
}
