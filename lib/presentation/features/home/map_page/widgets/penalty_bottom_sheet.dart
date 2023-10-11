import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../../domain/payment/models/card.dart';
import '../../../../utils/size_util.dart';

class PenaltyBottomSheet extends StatelessWidget {
  final Penalty penalty;
  final List<UserCard> cards;
  final Function()? ifEmpty;
  final Function(UserCard)? onCardTap;
  final Function(UserCard)? pay;
  const PenaltyBottomSheet({Key? key, required this.penalty, required this.cards,  this.ifEmpty,  this.onCardTap, this.pay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
          Text('${penalty.cost}₽ не были списаны', style: AppStyle.black16.copyWith(fontWeight: FontWeight.bold),),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Деньги в прошлый раз не были списаны. Перед началом следующей поездки, необходимо оплатить штраф.'),),
            Divider(indent: 0, endIndent: 0, color: Colors.grey.withOpacity(0.5),thickness: 1,),
            Padding(padding: const EdgeInsets.symmetric(vertical: 20),
            child: cards.isEmpty ? TextButton(onPressed: ifEmpty , child: Text('Добавить карту', style: AppStyle.black16.copyWith(color: AppColor.firstColor),)) : GestureDetector(
              onTap: (){ if(onCardTap != null) onCardTap!(cards.last);},
              child: Container(
                child: Row(
                  children: [
                    SvgPicture.asset(AppImages.card, color: AppColor.firstColor, height: 20,),
                    const SizedBox(width: 10,),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('**** ${cards.last.number.substring(cards.last.number.length - 4, cards.last.number.length)}')),
                  ],
                ),
              ),
            ),
            ),
            Center(
              child: AppElevatedButton(
                  text: 'Оплатить',
                  onTap: () {
                    if(cards.isNotEmpty && pay != null) {
                      pay!(cards.last);
                    } else {
                      showDialog(context: context, builder: (context) =>Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Добавьте карту для оплаты', style: AppStyle.black14,overflow: TextOverflow.visible,),
                                  const SizedBox(height: 30,),
                                  Center(child: AppElevatedButton(text: 'ОК', onTap: ()=> context.pop()))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
