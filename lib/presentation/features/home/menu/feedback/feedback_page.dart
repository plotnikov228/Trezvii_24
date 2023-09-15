import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';

import '../../../../utils/app_style_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../ui/widgets/menu_chapter.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppPopButton(context,
                      text: 'Обратная связь',
                      onTap: () => context
                          .read<MenuBloc>()
                          .add(GoMenuEvent(newState: InitialMenuState())),
                      color: Colors.black,
                      textStyle: AppStyle.black16),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Написать в VK',
                      prefixWidget: SvgPicture.asset(
                        AppImages.vk,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        color: AppColor.firstColor,
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Написать в Одноклассники',
                      prefixWidget: SvgPicture.asset(
                        AppImages.ok,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        color: AppColor.firstColor,
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Написать в Instagram',
                      prefixWidget: SvgPicture.asset(
                        AppImages.instagram,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        color: AppColor.firstColor,
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Написать в Facebook',
                      prefixWidget: SizedBox(width: 30,height: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.facebook,
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                            color: AppColor.firstColor,
                          ),
                        ),
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Написать в службу поддержки',
                      prefixWidget: SizedBox(width: 30,height: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.support,
                            width: 18,
                            height: 18,
                            fit: BoxFit.cover,
                            color: AppColor.firstColor,
                          ),
                        ),
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:40,top: 20),
                  child: menuChapter(
                      title: 'Позвонить оператору',
                      prefixWidget: SizedBox(width: 30,height: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.operator,
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                            color: AppColor.firstColor,
                          ),
                        ),
                      ),
                      onTap: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
