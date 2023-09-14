import 'package:flutter/material.dart';

import '../../utils/app_style_util.dart';
import '../../utils/size_util.dart';
import '../../widgets/app_pop_button.dart';
import '../../widgets/composite_text_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  void goToPrivacyPolicy () {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AppPopButton(context,
                text: 'Политика конфиденциальности',
                color: Colors.black,
                textStyle: AppStyle.black16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, top: 20, right: 40),
          child: CompositeTextWidget(
            onSubtitleTap: goToPrivacyPolicy,
            width: size.width - 80,
            title:
                'Оформления заказ в данном мобильном приложении вы соглашаетесь с условиями политики конфиденциальности, с которой можно ознакомиться по ссылке:',
            spaceBetweenTitles: 20,
            subTitle: 'Политика конфиденциальности',
          ),
        )
      ],
    )));
  }
}
