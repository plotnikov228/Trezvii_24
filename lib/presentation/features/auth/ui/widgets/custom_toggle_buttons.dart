import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

class CustomToggleButtons extends StatelessWidget {
  final List<Widget> prefixWidgets;
  final Function(int) onChange;
  final int currentIndex;

  const CustomToggleButtons(
      {super.key,
      required this.prefixWidgets,
      required this.onChange,
      required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List.generate(prefixWidgets.length, (index) {
        final e = prefixWidgets[index];
        return InkWell(
          onTap: () {
            if(currentIndex != index) {
              onChange(index);
            }
          },
          child: SizedBox(height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                e,
                const SizedBox(
                  width: 2,
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColor.firstColor, width: 2),
                      shape: BoxShape.circle),
                  child: currentIndex != index ? null : Center(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: AppColor.firstColor, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
