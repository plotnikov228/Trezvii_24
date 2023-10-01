import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/state.dart';
import 'package:sober_driver_analog/presentation/widgets/custom_tab_button.dart';
import 'package:sober_driver_analog/presentation/widgets/number_text_form_field.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../utils/size_util.dart';

class InputCodePage extends StatelessWidget {
  final AuthBloc bloc;
  final InputCodeState state;

  const InputCodePage({super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.add(ChangeAuthStateEvent(bloc.previousState ?? bloc.currentState!));

        return false;
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          AppColor.firstColor,
          Colors.white,
          Colors.white,
          Colors.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 16),
                  child: InkWell(
                    onTap: () {
                      bloc.add(ChangeAuthStateEvent(bloc.previousState ?? bloc.currentState!));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              AppImages.rightArrow,
                              width: 12,
                              height: 20,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 27),
                          child: Text(
                            'Введите код из смс',
                            style: AppStyle.black22.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 2 - 150, left: 30, right:  30),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Pinput(
                      showCursor: false,
                      length: 6,
                      separatorBuilder: (_) {
                        return const SizedBox(width: 10,);
                      },
                      preFilledWidget:  Center(child: Text('·', style: AppStyle.black36.copyWith(fontWeight: FontWeight.bold), )),
                      controller: state.codeController,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                      defaultPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5,
                                  style: BorderStyle.none)))),
                      focusedPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5)))),
                      disabledPinTheme:PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5)))),
                      followingPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5)))),
                      submittedPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5)))),
                      errorPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: AppStyle.black36,
                          decoration: BoxDecoration(

                              border: Border(
                                  bottom: BorderSide(
                                      color: AppColor.grayForPin, width: 5)))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                      child: AppElevatedButton(
                          text: 'Авторизоваться',
                          onTap: () {
                            if(state.codeController!.text.length < 6) {
                              AppSnackBar.showSnackBar(context, content: 'Введите пинкод');
                            } else {
                              bloc.add(InputCodeAuthEvent(context));
                            }
                          },
                          height: 45,
                          width: size.width - 37 * 2)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
