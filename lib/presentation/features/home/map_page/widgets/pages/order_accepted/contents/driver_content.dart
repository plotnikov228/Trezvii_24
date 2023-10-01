import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/extensions/duration_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/route_card_widget.dart';

import '../../../../../../../utils/app_color_util.dart';
import '../../../../../../../utils/app_images_util.dart';
import '../../../../../../../utils/app_style_util.dart';
import '../../../../../../../utils/size_util.dart';
import '../../../../../../../widgets/rating_widget.dart';
import '../../../../bloc/event/event.dart';

class OrderAcceptedDriverContent extends StatelessWidget {
  const OrderAcceptedDriverContent({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    return Column(
      children: [
        const Text('Доберитесь до клиента', style: AppStyle.black17,),
        const SizedBox(height: 10,),
        Row(children: [
          const Icon(
            Icons.location_pin,
            color: Colors.black87,
            size: 24,
          ),
          const SizedBox(width: 5,),
          Text(bloc.fromAddress!.addressName)
        ],),
        const SizedBox(height: 10,),
        routeCardWidget(bloc.routeStream!),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
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
            ),
          ),
        )
      ],
    );
  }
}
