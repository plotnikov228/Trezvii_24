import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/widgets/number_text_form_field.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_check_box.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_snack_bar.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../../../widgets/custom_tab_button.dart';

class SignUpPage extends StatelessWidget {
  final AuthBloc bloc;
  final SignUpState state;

  const SignUpPage({super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Container(
      width: size.width,
      height: size.height,
      color: AppColor.firstColor,
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              const SizedBox(
                height: 274,
              ),
              Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -5),
                      color: Colors.white38,
                      blurRadius: 20,
                      spreadRadius: 10),
                ],borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 46),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomTabButton(text: 'Регистрация для пользователей', width: 180),
                              CustomTabButton(text: 'Вход', width: 70,
                                  onTap: () =>
                                      bloc.add(ChangeAuthStateEvent(SignInState())),
                                  isSelected: false
                              ),
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
                          color: AppColor.lightGray,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 41),
                        child: AppTextFormField(state.emailController!,
                            validator: (text) {
                          if (text!.trim() == "") {
                            return "Заполните поле";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text)) {
                            return 'Пожалуйста введите верный формат вашей почты';
                          }
                        },
                            keyboardType: TextInputType.emailAddress,
                            focusNode: FocusNode(),
                            height: 45,
                            width: size.width - 80,
                            textInputAction: TextInputAction.next,
                            hintText: 'notification'),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: NumberTextFormField(state.numberController!,
                              width: size.width - 80,
                              height: 65,)),
                      Padding(
                        padding: const EdgeInsets.only(top: 19),
                        child: AppElevatedButton(
                            text: 'Зарегестрироваться',
                            height: 70,
                            width: size.width - 80,
                            onTap: () {
                              if (!state.checkBoxIsAccepted!) {
                                AppSnackBar.showSnackBar(context,
                                    content:
                                        'Дайте согласие на обработку данных');
                              }
                              else if (!key.currentState!.validate()) {
                                if (state.emailController!.text.trim() == "") {
                                  AppSnackBar.showSnackBar(context,
                                      content: 'Заполните поле');
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(state.emailController!.text)) {
                                  AppSnackBar.showSnackBar(context,
                                      content: 'Введите верный формат почты');
                                } else if (state.numberController!.text
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
                              }
                                bloc.add(SignUpEvent(
                                    textFieldHasError:
                                        !key.currentState!.validate() || !state.checkBoxIsAccepted!));
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 42, bottom: 42),
                        child: AppCheckBox(
                          text: 'Даю согласие на обработку данных',
                          onChange: (val) {

                            bloc.add(SignUpEvent(updatedCheckBoxValue: val, textFieldHasError: !key.currentState!.validate() || !val));
                          },
                          iconSize: 25,
                          width: size.width - 80,
                          value: state.checkBoxIsAccepted,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
