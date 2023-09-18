
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/balance/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/balance/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/balance/bloc/state.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_elevated_button.dart';
import '../../../../widgets/app_pop_button.dart';
import '../../../../widgets/app_text_form_field.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class BalancePage extends StatelessWidget {

  const BalancePage(
      {super.key,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BalanceBloc>();
    return Scaffold(
      body: BlocBuilder<BalanceBloc, BalanceState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
            return false;
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: AppPopButton(context,
                    text: 'Баланс',
                    onTap: () => context
                        .read<MenuBloc>()
                        .add(GoMenuEvent(newState: InitialMenuState())),
                    color: Colors.black,
                    textStyle: AppStyle.black16),
              ),
              /*const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Text(
                  'Баланс',
                  style: AppStyle.black17,
                ),
              ),*/
              Padding(
                  padding: const EdgeInsets.only(top: 48, bottom: 15),
                  child: IgnorePointer(child: Center(child: AppTextFormField(TextEditingController(text: '${state.balance}'),

                  )))
              ),
              const Text('Для перевода, нажмите на кнопку: “Вывести средства”', style: AppStyle.black14, overflow: TextOverflow.visible,),
              Visibility(
                visible: state.balance != 0,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: size.width,
                      height: 91,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -5),
                                color: Colors.black12,
                                spreadRadius: 5,
                                blurRadius: 5)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: AppElevatedButton(
                            width: size.width - 60,
                            height: 38,
                            text: 'Вывести средства',
                            onTap: () {
                              bloc.add(WithdrawalOfFundsBalanceEvent());
                            }),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
