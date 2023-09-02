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
import '../../../../widgets/app_check_box.dart';

class AuthDriverPage extends StatelessWidget {
  final AuthBloc bloc;
  final AuthDriverState state;

  const AuthDriverPage({super.key, required this.bloc, required this.state});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomTabButton(
                                  text: 'Регистрация для пользователей',
                                  width: 180,
                                  onTap: () =>
                                      bloc.add(ChangeAuthStateEvent(SignUpState())),
                                  isSelected: false),
                              CustomTabButton(text: 'Вход', width: 70,
                                  isSelected: false,
                                  onTap: () => bloc.add(ChangeAuthStateEvent(SignInState()),

                                  )
                              ),
                              CustomTabButton(
                                text: 'Регистрация для водителей',
                                width: 160,),
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
                              'Что бы приступить к работе, необходимо заполнить некоторые данные',
                              style: AppStyle.black14,

                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: AppElevatedButton(
                                text: 'Данные водителя',
                                onTap: () {
                                  bloc.add(ChangeAuthStateEvent(DriverDataState()));
                                },
                                height: 52,
                                width: size.width - 150,
                                textColor: state.firstComplete! ? Colors.white : Colors.black,
                                shade: true,
                              bgColor: state.firstComplete! ? AppColor.firstColor : Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: AppElevatedButton(
                              text: 'Данные автомобиля',

                              onTap: () {
                                bloc.add(ChangeAuthStateEvent(CarDataState()));
                              },
                              height: 52,
                              width: size.width - 150,
                              textColor: state.secondComplete! ? Colors.white : Colors.black,
                              shade: true,
                              bgColor: state.secondComplete! ? AppColor.firstColor : Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: AppElevatedButton(
                                textColor: state.thirdComplete! ? Colors.white : Colors.black,

                                shade: true,
                                bgColor: state.thirdComplete! ? AppColor.firstColor : Colors.white,
                                text: 'Проверка фотографий',
                                onTap: () {
                                  bloc.add(ChangeAuthStateEvent(EnterPhotoState()));
                                },
                                height: 52,
                                width: size.width - 150)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: AppElevatedButton(
                            text: 'Отправить данные на проверку',
                            onTap: () {
                              if(!state.checkBoxIsAccepted!) {
                                AppSnackBar.showSnackBar(context, content: 'Дайте согласие на обработку данных');
                              }
                              else if(state.firstComplete! && state.secondComplete! && state.thirdComplete!) {
                                bloc.add(CreateRequestEvent());
                              } else {
                                AppSnackBar.showSnackBar(context, content: 'Вы ещё не заполнили все данные');
                              }
                            },
                            height: 62,
                            width: size.width - 48 * 2,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: AppCheckBox(
                          text: 'Даю согласие на обработку данных',
                          onChange: (val) {
                            bloc.add(ChangeAuthStateEvent(AuthDriverState(checkBoxIsAccepted: val)));
                          },
                          iconSize: 25,
                          width: size.width - 106,
                          value: state.checkBoxIsAccepted,
                        ),
                      ),
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
