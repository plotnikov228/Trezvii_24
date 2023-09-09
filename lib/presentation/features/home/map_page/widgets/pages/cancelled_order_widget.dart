import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_elevated_button.dart';
import '../../../../../widgets/app_text_form_field.dart';
import '../../../../../widgets/circle_toggle_button.dart';

class CanceledOrderWidget extends StatefulWidget {
  final MapBloc bloc;
  final CancelledOrderMapState state;

  const CanceledOrderWidget(
      {super.key, required this.bloc, required this.state});

  @override
  State<CanceledOrderWidget> createState() => _CanceledOrderWidgetState();
}

class _CanceledOrderWidgetState extends State<CanceledOrderWidget> {
  final textFieldFocusNode = FocusNode();
  String? currentReason;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.bloc.add(GoMapEvent(widget.bloc.previousState!));
        return false;
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    'Причина отмены заказа  ',
                    style: AppStyle.black17,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 48, bottom: 20),
                    child: Wrap(
                      spacing: 10,
                      direction: Axis.vertical,
                      children: widget.state.reasons!
                          .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e,
                                    style: AppStyle.black15,
                                  ),
                                  circleToggleButton(
                                      value: currentReason == e,
                                      onChange: (val) {
                                        if (val && e != 'Другая причина:') {
                                          currentReason = e;
                                        } else if (val &&
                                            e == 'Другая причина:') {
                                          textFieldFocusNode.requestFocus();
                                        }
                                        if (currentReason == e && !val) {
                                          currentReason = null;
                                        }
                                        setState(() {});
                                      })
                                ],
                              ))
                          .toList(),
                    )),
                IgnorePointer(
                  ignoring: currentReason !=
                      widget.state.reasons[widget.state.reasons.length - 1],
                  child: AppTextFormField(widget.state.otherReason!,
                      width: size.width - 40,
                      height: 160,
                      hintText: 'Другая причина',
                      textInputAction: TextInputAction.newline,
                      maxLength: 200,
                      focusNode: textFieldFocusNode),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: AppElevatedButton(
                  width: size.width - 40,
                  text: 'Готово',
                  onTap: () {
                    if (currentReason != null) {

                      widget.bloc.add(CancelOrderMapEvent(currentReason !=
                          widget.state.reasons[widget.state.reasons.length - 1] ? currentReason! :widget.state.otherReason!.text));
                    } else {
                      AppSnackBar.showSnackBar(context,
                          content: 'Выберите причину отмены');
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
