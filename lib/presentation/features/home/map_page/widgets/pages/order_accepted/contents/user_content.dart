import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/extensions/duration_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../../utils/app_color_util.dart';
import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/app_style_util.dart';
import '../../../../../../../utils/size_util.dart';
import '../../../../../../../widgets/rating_widget.dart';
import '../../../../bloc/event/event.dart';

class OrderAcceptedUserContent extends StatelessWidget {
  final OrderAcceptedMapState state;
  const OrderAcceptedUserContent({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          child: Text(
            'Время подачи - ${state.waitingTime!.calculateTimeBetweenDates()}',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            ratingWidget(state.driver!.getRating()),
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
                        state.driver!.personalDataOfTheDriver!.driverPhotoUrl,
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
                  bloc.add(GoMapEvent(CancelledOrderMapState()));
                }, icon: Icon(Icons.close, color:  AppColor.firstColor, size: 30,)),
            IconButton(
                onPressed: () {
                  //some func
                },
                icon: SvgPicture.asset(AppImages.call, color:  AppColor.firstColor,)),
            IconButton(
                onPressed: () {
                  bloc.add(GoToChatMapEvent(context));
                  //some func
                },
                icon: SvgPicture.asset(AppImages.chatRoom, width: 30, height: 30, color:  AppColor.firstColor,))
          ],
        )
      ],
    );
  }
}
