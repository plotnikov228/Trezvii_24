import 'package:flutter/material.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';

class SelectTimeTab extends StatefulWidget {
  final MapBloc bloc;
  final AddWishesMapState state;

  const SelectTimeTab({super.key, required this.bloc, required this.state});

  @override
  State<SelectTimeTab> createState() => _SelectTimeTabState();
}

class _SelectTimeTabState extends State<SelectTimeTab> {
  bool preliminary = false;

  late final FixedExtentScrollController _controllerDates;
  late final FixedExtentScrollController _controllerHours;
  late final FixedExtentScrollController _controllerMinutes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dates = _getDates();
    hours = List<int>.generate(24, (index) => index);
    minutes = List<int>.generate(60 ~/ 5, (index) {
      return index * 5;
    });
    for (var i = 0; i < dates.length; i++) {
      if (now.month == dates[i].month && now.day == dates[i].day) {
        currentDateIndex = i;
        break;
      }
    }
    for (var i = 0; i < minutes.length; i++) {
      if ((now.minute - minutes[i]).abs() <= 5) {
        currentMinutesIndex = i;
        break;
      }
    }

    for (var i = 0; i < hours.length; i++) {
      if (now.hour == hours[i]) {
        currentHourIndex = i;
        break;
      }
    }

    initialDateIndex = currentDateIndex;
    initialHourIndex = currentHourIndex;
    initialMinutesIndex = currentMinutesIndex;

    _controllerDates =
        FixedExtentScrollController(initialItem: initialDateIndex);
    _controllerMinutes =
        FixedExtentScrollController(initialItem: initialMinutesIndex);
    _controllerHours =
        FixedExtentScrollController(initialItem: initialHourIndex);

    controllersJump();
  }

  final now = DateTime.now();

  List<DateTime> dates = [];
  List<int> hours = [];
  List<int> minutes = [];

  int initialDateIndex = 0;
  int initialHourIndex = 0;
  int initialMinutesIndex = 0;

  int currentDateIndex = 0;
  int currentHourIndex = 0;
  int currentMinutesIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Предварительный заказ',
                style: AppStyle.black14,
              ),
              Switch(
                  thumbColor: MaterialStateProperty.resolveWith((Set states) {
                    return Colors.white;
                  }),
                  trackOutlineColor:  MaterialStateProperty.resolveWith((Set states) {
                    if(preliminary) return AppColor.firstColor;

                    return AppColor.gray;
                  }),
                  activeTrackColor: AppColor.firstColor,
                  inactiveTrackColor: AppColor.gray,
                  value: preliminary,
                  onChanged: (val) {
                    preliminary = val;
                    checkDate();
                    setState(() {});
                  })
            ],
          ),
          IgnorePointer(
            ignoring: !preliminary,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: 200,
                width: size.width - 40,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width / 2 - 40,
                          child: ListWheelScrollView.useDelegate(
                            magnification: 1.5,
                            controller: _controllerDates,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                currentDateIndex = index;
                              });
                              checkDate();
                            },
                            itemExtent: 55,
                            childDelegate: ListWheelChildLoopingListDelegate(
                              children: List<Widget>.generate(
                                  dates.length,
                                      (index) => Text(
                                    dates[index].day == DateTime.now().day &&
                                        dates[index].month ==
                                            DateTime.now().month
                                        ? 'Сегодня'
                                        : '${dates[index].getWeekDay()} ${dates[index].day} ${dates[index].getMonth()}',
                                    style: index != currentDateIndex
                                        ? AppStyle.gray22
                                        : AppStyle.gray22
                                        .copyWith(color: Colors.black),
                                  ),
                          ),
                ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 4,
                          child: ListWheelScrollView.useDelegate(
                            magnification: 1.5,
                           controller: _controllerHours,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                currentHourIndex = index;
                              });
                              checkDate();
                            },
                            itemExtent: 55,
                            childDelegate: ListWheelChildLoopingListDelegate(
                              children: List<Widget>.generate(
                                  hours.length,
                                      (index) => Text(
                                    '${hours[index]}',
                                    style: index != currentHourIndex
                                        ? AppStyle.gray22
                                        : AppStyle.gray22
                                        .copyWith(color: Colors.black),
                                  )),
                        ),

                          ),
                        ),
                        SizedBox(
                          width: size.width / 4,
                          child: ListWheelScrollView.useDelegate(
                            magnification: 1.5,
                            controller: _controllerMinutes,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                currentMinutesIndex = index;
                              });
                              checkDate();
                            },
                            itemExtent: 55,
                            childDelegate: ListWheelChildLoopingListDelegate(
                          children: List<Widget>.generate(
                            minutes.length,
                                    (index) => Text(
                                  '${minutes[index]}',
                                  style: index != currentMinutesIndex
                                      ? AppStyle.gray22
                                      : AppStyle.gray22
                                      .copyWith(color: Colors.black),
                                )),
                        ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Divider(indent: 0, endIndent: 0, color: Colors.grey,),
                            Divider(indent: 0, endIndent: 0, color: Colors.grey,)

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DateTime> _getDates() {
    final now = DateTime.now();
    final DateTime nextMonthStart = DateTime(now.year, now.month + 1, now.day);
    final DateTime prevMonthStart = DateTime(now.year, now.month - 1, now.day);
    return _getDatesBetween(prevMonthStart, nextMonthStart);
  }

  List<DateTime> _getDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return dates;
  }

  void checkDate() {
    final newDate = DateTime(
        dates[currentDateIndex].year,
        dates[currentDateIndex].month,
        dates[currentDateIndex].day,
        hours[currentHourIndex],
        minutes[currentMinutesIndex]);

    if (now.isAfter(newDate)) {
      currentHourIndex = initialHourIndex;
      currentMinutesIndex = initialMinutesIndex;
      currentDateIndex = initialDateIndex;
      controllersJump();
    } else {
      widget.bloc.add(AddPreliminaryTimeMapEvent(newDate, preliminary));
    }
  }

  void controllersJump() {
    _controllerDates.animateToItem(currentDateIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _controllerHours.animateToItem(currentHourIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _controllerMinutes.animateToItem(currentMinutesIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
