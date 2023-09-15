
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/widgets/composite_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';



class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  void onPrivacyPolicyTap (BuildContext context) {
    context.pushNamed(AppRoutes.privacyPolicy);
  }

  void onRequestTap (BuildContext context) async {
    await FirebaseRemoteConfig.instance.activate();
    await FirebaseRemoteConfig.instance.fetch();
   final emailStr = FirebaseRemoteConfig.instance.getString('support_email');
   if(emailStr.isNotEmpty) {
     String email = Uri.encodeComponent(emailStr);
     String subject = Uri.encodeComponent("Запрос на удаление / изменение / получение копии перональных данных");
     String body = Uri.encodeComponent("Опишите ваш запрос");
     Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
     if (await launchUrl (mail)
    ) {
//notification app opened
    }else{
//notification app is not opened
    }
  }
  }
  void onYandexPrivacyPolicyTap (BuildContext context) async {
    await FirebaseRemoteConfig.instance.activate();
    await FirebaseRemoteConfig.instance.fetch();
    launchUrl(Uri.parse(FirebaseRemoteConfig.instance.getString('yandex_privacy_policy_key')));
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
        child: CompositeTextWidget(title: 'Политика конфиденциальности',            width: size.width - 80,

          onTap: () => onPrivacyPolicyTap ( context),
        ),
        ),
        Padding(padding: EdgeInsets.only(left: 40, top: 20),
          child: CompositeTextWidget(title: 'Запрос на удаление / изменение / получение копии перональных данных',            width: size.width - 80,

            onTap: () => onRequestTap ( context),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 40, top: 20),
          child: CompositeTextWidget(title: 'Политика конфиденциальноти сервиса: “Яндекс.Карты”',            width: size.width - 80,

            onTap: () => onYandexPrivacyPolicyTap ( context),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 40, top: 20),
          child: CompositeTextWidget(title: 'Обучение',
            width: size.width - 80,
            onTap: () => onTutorialTap ( context),
          ),
        ),
      ],
    ))));
  }
}
