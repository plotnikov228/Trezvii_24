import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/adresses_buttons.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../widgets/point_widget.dart';

Widget routeCardWidget(Stream<DrivingRoute> route,
    {AddressModel? from, AddressModel? to}) {
  return StreamBuilder(
      stream: route,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Произошла ошибка получения маршрута, проверьте подключение к интернету!',
              style: AppStyle.black16,
              overflow: TextOverflow.visible,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(
                color: AppColor.firstColor,
              ),
            ),
          );
        }

        final km = (snapshot.data!.metadata.weight.distance.value ?? 50) / 1000;
        final minutes =
            (snapshot.data!.metadata.weight.timeWithTraffic.value ?? 1600) ~/
                60;
        return Column(
          children: [
            if (from != null && to != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AddressesButtons(
                  from: from,
                  to: to,
                ),
              ),
            if (from == null && to != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.black87,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      to.addressName,
                      style: AppStyle.black16,
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText.rich(TextSpan(children: [
                    const TextSpan(
                        text: 'Осталось километров:', style: AppStyle.black15),
                    TextSpan(
                        text: ' $km км',
                        style: AppStyle.black15
                            .copyWith(fontWeight: FontWeight.bold))
                  ]))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText.rich(TextSpan(children: [
                  const TextSpan(
                      text: 'Осталось времени:', style: AppStyle.black15),
                  TextSpan(
                      text:
                          minutes > 60 ? '${minutes ~/ 60} ч' : '$minutes мин',
                      style: AppStyle.black15
                          .copyWith(fontWeight: FontWeight.bold))
                ]))
              ],
            ),
          ],
        );
      });
}
