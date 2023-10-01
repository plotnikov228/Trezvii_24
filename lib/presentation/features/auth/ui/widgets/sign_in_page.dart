import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/state.dart';
import 'package:sober_driver_analog/presentation/widgets/custom_tab_button.dart';
import 'package:sober_driver_analog/presentation/widgets/number_text_form_field.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../utils/size_util.dart';

class SignInPage extends StatelessWidget {
  final AuthBloc bloc;
  final SignInState state;

  const SignInPage({super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        AppColor.firstColor,
        Colors.white,
        Colors.white,
        Colors.white,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 394,
              width: size.width - 29 * 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 10, spreadRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 33),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomTabButton(
                              text: 'Регистрация для пользователей',
                              width: 180,
                              onTap: () =>
                                  bloc.add(ChangeAuthStateEvent(SignUpState())),
                              isSelected: false),
                          CustomTabButton(text: 'Вход', width: 70),
                          CustomTabButton(
                              text: 'Регистрация для водителей',
                              width: 160,
                              onTap: () =>
                                  bloc.add(ChangeAuthStateEvent(AuthDriverState())),
                              isSelected: false),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Divider(
                      indent: 0,
                      endIndent: 0,
                      thickness: 1,
                      color: AppColor.lightGray,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                    ),
                    child: Center(
                        child: Text(
                      'Введите свой номер телефона',
                      style: AppStyle.black17,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Center(
                        child: NumberTextFormField(state.numberController!,
                            width: size.width - 48 * 2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                        child: AppElevatedButton(
                            text: 'Далее',
                            onTap: () {
                              if (!key.currentState!.validate()) {
                                if (state.numberController!.text
                                    .trim()
                                    .isEmpty) {
                                  AppSnackBar.showSnackBar(context,
                                      content: 'Заполните поле ввода номера');
                                } else if (state.numberController!.text
                                        .trim()
                                        .length <
                                    10) {
                                  AppSnackBar.showSnackBar(context,
                                      content:
                                          'Введите верный формат номера телефона');
                                }
                              } else
                              bloc.add(SignInEvent(
                                  textFieldHasError:
                                      !key.currentState!.validate()));
                            },
                            height: 62,
                            width: size.width - 48 * 2)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
