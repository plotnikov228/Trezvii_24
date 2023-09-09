import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_duration_between_two_points.dart';
import 'package:sober_driver_analog/extensions/duration_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';

import '../../../../../../../data/map/repository/repository.dart';
import '../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';


class OrderAcceptedWidget extends StatefulWidget {
  final MapBloc bloc;
  final OrderAcceptedMapState state;
  const OrderAcceptedWidget({super.key, required this.bloc, required this.state});

  @override
  State<OrderAcceptedWidget> createState() => _OrderAcceptedWidgetState();
}

class _OrderAcceptedWidgetState extends State<OrderAcceptedWidget> {
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
                'Время подачи - ${widget.state.waitingTime!.calculateTimeBetweenDates()}',
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
                              widget.state.driver!.name,
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
                                  widget.state.driver!.getRating(),
                                  style: AppStyle.black14
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.state.distance!,
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
                            widget.state.driver!.personalDataOfTheDriver.driverPhotoUrl,
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
                      widget.bloc.add(GoMapEvent(CancelledOrderMapState()));
                    }, icon: const Icon(Icons.close, color:  Colors.deepPurple, size: 30,)),
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
