import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';

import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../bloc/state/state.dart';

class OrderCompletedPage extends StatelessWidget {
  final OrderCompleteMapState state;
   OrderCompletedPage({Key? key, required this.state}) : super(key: key);
   bool changed = false;
   double rating = 0;
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
                'Поездка завершна, ${AppOperationMode.userMode() ? 'Оцените водителя' : 'Оцените клиента'}',
                style: AppStyle.black16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: RatingBar.builder(
                  initialRating: rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (_) {
                    rating = _;
                    changed = true;
                  },
                  itemCount: 5,
                  itemSize: 50.0,
                  unratedColor: Colors.amber.withAlpha(50),
                ),
              ),
            ),
            AppElevatedButton(width: size.width - 80, text: 'Продолжить', onTap: () {
                context.read<MapBloc>().add(CompleteOrderMapEvent(rating: changed ? rating : null, id: state.id, orderId: state.orderId));
            })
          ],
        ),
      ),
    );
  }
}
