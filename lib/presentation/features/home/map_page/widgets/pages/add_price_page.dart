import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';

import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';

class AddPricePage extends StatefulWidget {
  final MapBloc bloc;
  final AddPriceMapState state;

  const AddPricePage({super.key, required this.bloc, required this.state});

  @override
  State<AddPricePage> createState() => _AddPricePageState();
}

class _AddPricePageState extends State<AddPricePage> {
  int count = 0;

  void dicrement() {
    count -= 100;
    if (count < 0) count = 0;
    setState(() {});
  }

  void increment() {
    count += 100;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
       widget.bloc.add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
        return false;
      },
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.grey.withOpacity(0.4),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: 214,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16), topLeft: Radius.circular(16))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Увеличить стоимость поездки',
                  style: AppStyle.black16,
                ),
                SizedBox(
                  width: size.width - 140,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              dicrement();
                            },
                            icon: Text('－',
                                style: AppStyle.black36
                                    .copyWith(color: AppColor.firstColor))),
                        Text(
                          '$count',
                          style: AppStyle.black36,
                        ),
                        IconButton(
                            onPressed: () {
                              increment();
                            },
                            icon: Text('+',
                                style: AppStyle.black36
                                    .copyWith(color: AppColor.firstColor))),

                      ],
                    ),
                  ),

                ),
                AppElevatedButton(
                  text: '',
                    width: size.width - 68,
                    onTap: () {
                    widget.bloc.add(ChangeCostMapEvent(widget.state.order!.costInRub + count));
                    },
                    prefixWidget: Text(
                      '~ ${widget.state.order!.costInRub + count}',
                      style: AppStyle.black16.copyWith(color: Colors.white),
                    ),
                    suffixWidget: Text(
                      'Готово',
                      style: AppStyle.black16.copyWith(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
