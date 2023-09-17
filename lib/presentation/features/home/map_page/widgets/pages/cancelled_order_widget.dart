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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    'Причина отмены заказа  ',
                    style: AppStyle.black17,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 20, left: 35, right: 25),
                  child: Wrap(
                    spacing: 10,
                    direction: Axis.vertical,
                    children: widget.state.reasons!
                        .map((e) => SizedBox(
                      width: size.width - 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e,
                                    style: AppStyle.black15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: circleToggleButton(
                                        value: currentReason == e,
                                        onChange: (val) {
                                          if (val && e != 'Другая причина:') {
                                            currentReason = e;
                                          } else if (val &&
                                              e == 'Другая причина:') {
                                            textFieldFocusNode.requestFocus();
                                            currentReason = e;
                                          }
                                          setState(() {});
                                        }),
                                  )
                                ],
                              ),
                        ))
                        .toList(),
                  )),
              IgnorePointer(
                ignoring: currentReason !=
                    widget.state.reasons[widget.state.reasons.length - 1],
                child: Center(
                  child: AppTextFormField(widget.state.otherReason!,
                      width: size.width - 40,
                      height: 160,
                      hintText: 'Другая причина',
                      textInputAction: TextInputAction.newline,
                      maxLength: 200,
                      focusNode: textFieldFocusNode),
                ),
              ),Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Center(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
