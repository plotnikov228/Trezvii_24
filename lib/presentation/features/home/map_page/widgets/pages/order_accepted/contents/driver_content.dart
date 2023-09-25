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
    return routeCardWidget(bloc.routeStream!);
  }
}
