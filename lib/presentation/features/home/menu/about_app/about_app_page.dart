import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/widgets/composite_text_widget.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';



class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  void onPrivacyPolicyTap (BuildContext context) {
    context.pushNamed(AppRoutes.privacyPolicy);
  }

  void onRequestTap (BuildContext context) {

  }
  void onYandexPrivacyPolicyTap (BuildContext context) {

  }

  void onTutorialTap (BuildContext context) {
    context.pushNamed(AppRoutes.tutorial);
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async {
            context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
            return false;
          },
      child:Scaffold(body: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AppPopButton(context,
                onTap: () => context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState())),
                text: 'О приложении', color: Colors.black, textStyle: AppStyle.black16),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 40, top: 20),
        child: CompositeTextWidget(title: 'Политика конфиденциальности'),
        )
      ],
    ))));
  }
}
