import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sober_driver_analog/presentation/features/auth/ui/widgets/custom_toggle_buttons.dart';
import 'package:sober_driver_analog/presentation/text_field_formatters/date_text_formatter.dart';
import 'package:sober_driver_analog/presentation/widgets/image_button.dart';
import 'package:sober_driver_analog/presentation/widgets/number_text_form_field.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_check_box.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../../../../widgets/app_snack_bar.dart';
import '../../../../widgets/bottom_sheet_for_select_photo.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../../../widgets/custom_tab_button.dart';

class EnterPhotoPage extends StatelessWidget {
  final AuthBloc bloc;
  final EnterPhotoState state;

  const EnterPhotoPage({super.key, required this.bloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async {
        bloc.add(ChangeAuthStateEvent(AuthDriverState()));
        return false;
      },
      child: Container(
        width: size.width,
        height: size.height,
        color: AppColor.firstColor,
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                      height: 274,
                      width: size.width,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 16),
                          child: AppPopButton(context,
                              text: 'Проверка фотографий',
                              color: Colors.white,
                              onTap: () => bloc.add(
                                  ChangeAuthStateEvent(AuthDriverState()))),
                        ),
                      )),
                  Container(
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
                              child: Wrap(
                                children: List.generate(
                                    state.titles!.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                            height: size.width / 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width / 3,
                                                  child: Text(
                                                    state.titles![index],
                                                    style: AppStyle.black16,
                                                  ),
                                                ),
                                                ImageButton(
                                                  file: state.files![index],
                                                  height: size.width / 3,
                                                  width: size.width / 2.5,
                                                  onTap: () => showBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) => BottomSheetForSelectPhoto(
                                                            onCameraTap: () {
                                                              bloc.add(InsertPhotoEvent(
                                                                  index,
                                                                  ImageSource
                                                                      .camera));
                                                              context.pop();
                                                            },
                                                            onGalleryTap: () {
                                                              bloc.add(InsertPhotoEvent(
                                                                  index,
                                                                  ImageSource
                                                                      .gallery));
                                                              context.pop();
                                                            },
                                                          )),
                                                )
                                              ],
                                            ),
                                          ),
                                    )),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 19),
                            child: AppElevatedButton(
                                text: state.nextState == null
                                    ? 'Завершить заполнение'
                                    : 'Далее',
                                height: 70,
                                width: size.width - 106,
                                onTap: () {
                                  if (!key.currentState!.validate()) {
                                    AppSnackBar.showSnackBar(context,
                                        content: 'Заполните все поля');
                                  }
                                  bloc.add(ChangeAuthStateEvent(
                                      state.nextState ?? AuthDriverState()));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
