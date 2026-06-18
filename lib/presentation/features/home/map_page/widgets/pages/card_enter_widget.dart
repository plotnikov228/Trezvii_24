import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/text_field_formatters/card_text_formatter.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../widgets/app_text_form_field.dart';
import '../../bloc/event/event.dart';
import '../../bloc/state/state.dart';
import '../map_bottom_bar.dart';

class CardEnterWidget extends StatelessWidget {
  const CardEnterWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final bloc = context.read<MapBloc>();
    final state = bloc.state as CardMapState;
    return WillPopScope(
      onWillPop: () async {
        bloc.add(GoMapEvent(AddCardMapState()));
        return false;
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 90),
                        child: IconButton(onPressed: (){
                          bloc.add(GoMapEvent(AddCardMapState()));

                        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
                      ),
                    ),
                    Center(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text(
                          'Введите данные карты',
                          style: AppStyle.black17,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 48, bottom: 0, left: 20, right: 20),
                    child: AppTextFormField(state.card,
                        width: 220,
                        hintText: '0000 0000 0000 0000', formatters: [CardTextInputFormatter()],maxLength: 19)
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextFormField(
                          width: 100,
                          state.cvc, maxLength: 3, hintText: 'cvc'),
                      SizedBox(width: 20,),
                      AppTextFormField(state.date,
                          width: 100,
                          maxLength: 5, hintText: 'mm/yy'),
                    ],
                  ),
                ),
                SizedBox(height: 60,),
                AppElevatedButton(text: 'Добавить',
                    width: 200,
                    onTap: () {
                  if(state.card.length != 19 && state.date.length < 5 && state.cvc != 3) {
                    AppSnackBar.showSnackBar(context, content: 'Вы ввели некоректные данные карты');
                  } else {
                    bloc.add(AddNewCardMapEvent());
                  }
                })
              ],
            ),



          ],
        ),
      ),
    );
  }
}
