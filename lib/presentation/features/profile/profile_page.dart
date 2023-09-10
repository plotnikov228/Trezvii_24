import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/profile/bloc/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_progress_container.dart';
import 'package:sober_driver_analog/presentation/widgets/image_button.dart';
import 'package:sober_driver_analog/presentation/widgets/user_photo_with_border.dart';

import '../../utils/app_color_util.dart';
import '../../utils/size_util.dart';
import '../../utils/status_enum.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_loading_message.dart';
import '../../widgets/app_pop_button.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/app_text_form_field.dart';
import '../../widgets/bottom_sheet_for_select_photo.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:AppColor.firstColor,
        body:BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(ProfileState(status: Status.Loading))..add(InitProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, current) =>
            prev.status == Status.Loading || current.status != Status.Success,
        listener: (context, state) {
          if (state.status == Status.Failed) {
            AppSnackBar.showSnackBar(context,
                content:
                    'Произошла ошибка, проверьте подключение к интернету или попробуйте позднее');
          }
        },
        builder: (BuildContext context, ProfileState state) {
          final bloc = context.read<ProfileBloc>();
          final key = GlobalKey<FormState>();
          return  Stack(
            children: [
              Form(
                    key: key,
                    child: SingleChildScrollView(
                child:SafeArea(
                  child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            width: size.width,
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: AppPopButton(
                                        context,
                                        text: 'Профиль',
                                        color: Colors.white,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: userPhotoWithBorder(
                                      size: 100,
                                        onTap: () => showBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                BottomSheetForSelectPhoto(
                                                  onCameraTap: () {
                                                    bloc.add(ChangePhotoProfileEvent(
                                                        ImageSource.camera));
                                                    context.pop();
                                                  },
                                                  onGalleryTap: () {
                                                    bloc.add(ChangePhotoProfileEvent(
                                                        ImageSource.gallery));

                                                    context.pop();
                                                  },
                                                )),
                                        file: state.imageFile,
                                        url: state.imageUrl,),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: size.height - 200,
                              alignment: Alignment.topCenter,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, -5),
                                        color: Colors.white38,
                                        blurRadius: 20,
                                        spreadRadius: 10),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40, right: 40),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 41),
                                      child: AppTextFormField(
                                          state.name ?? TextEditingController(),
                                          validator: (text) {
                                        if (text!.trim() == "") {
                                          return "Заполните поле";
                                        }
                                      },
                                          textInputAction: TextInputAction.next,
                                          focusNode: FocusNode(),
                                          height: 45,
                                          width: size.width - 80,
                                          hintText: 'Ваше имя'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: AppTextFormField(
                                          state.email ?? TextEditingController(),
                                          validator: (text) {
                                        if (text!.trim() == "") {
                                          return "Заполните поле";
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(text)) {
                                          return 'Пожалуйста введите верный формат вашей почты';
                                        }
                                      },
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.emailAddress,
                                          focusNode: FocusNode(),
                                          height: 45,
                                          width: size.width - 80,
                                          hintText: 'email'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 19),
                                      child: AppElevatedButton(
                                          text: 'Принять',
                                          height: 48,
                                          width: size.width - 80,
                                          onTap: () {
                                            if (!key.currentState!.validate()) {
                                              if (!RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(state.email!.text)) {
                                                AppSnackBar.showSnackBar(context,
                                                    content:
                                                        'Введите верный формат почты');
                                              } else {
                                                AppSnackBar.showSnackBar(context,
                                                    content:
                                                        'Поля не должны быть пустыми');
                                              }
                                            } else {
                                              bloc.add(CompleteChangesProfileEvent());
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
                  ),
                ),
              if(state.status == Status.Loading)
              Container(width: size.width,
              height: size.height, color: Colors.grey.withOpacity(0.3),
              child: Center(
                child: AppProgressContainer(),
              ),
              )
            ],
          );
        },
      ),
    ));
  }
}
