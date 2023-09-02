import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/map_page/bloc/state/state.dart';

import '../../../../../../utils/app_images_util.dart';
import '../../../../../../utils/app_style_util.dart';
import '../../../../../../utils/size_util.dart';
import '../../../../../../widgets/app_elevated_button.dart';
import '../../../../../../widgets/app_snack_bar.dart';
import '../../../../../../widgets/app_text_form_field.dart';
import '../../../../../../widgets/number_text_form_field.dart';
import '../../bloc/event/event.dart';

Widget wishesTab(BuildContext context, MapBloc bloc, AddWishesMapState state) {
  final key = GlobalKey<FormState>();
  final wishesFocusNode = FocusNode();
  return SingleChildScrollView(
    child: Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Комментарий',
            style: AppStyle.black14,
          ),
          AppTextFormField(state.wish!,
              width: size.width - 40,
              height: 160,
              hintText: '',
              textInputAction: TextInputAction.newline,
              maxLength: 200,
              focusNode: wishesFocusNode),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: 12,
              ),
              child: AppElevatedButton(
                  text: 'Готово',
                  width: 120,
                  onTap: () {
                    wishesFocusNode.unfocus();
                    if (key.currentState!.validate()) {
                      bloc.add(GoMapEvent(CreateOrderMapState()));
                    } else {
                      var snackBarText = '';
                      if (state.otherName!.text.isEmpty &&
                          state.otherNumber!.text.isNotEmpty) {
                        snackBarText = 'Заполните поле имени';
                      } else if (state.otherName!.text.isNotEmpty &&
                          state.otherNumber!.text.isEmpty) {
                        snackBarText = 'Заполните поле номера';
                      }
                      AppSnackBar.showSnackBar(context, content: snackBarText);
                    }
                  }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              'Вызвать водителя другому',
              style: AppStyle.black14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: AppTextFormField(state.otherName!,
                width: size.width - 100, maxLength: 40, validator: (text) {
              if (text!.isEmpty) return '';
            }),
          ),
          Row(
            children: [
              NumberTextFormField(
                state.otherNumber!,
                width: size.width - 100,
              ),
              InkWell(
                onTap: () => bloc.add(GetOtherFromContactsMapEvent()),
                child: SizedBox(
                  height: 49,
                  width: 49,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppImages.contacts,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        'Контакты',
                        style: AppStyle.black10
                            .copyWith(fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
