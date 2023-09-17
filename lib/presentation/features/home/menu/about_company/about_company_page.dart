import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_company/bloc/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/app_style_util.dart';
import '../../../../utils/size_util.dart';
import '../../../../widgets/app_pop_button.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class AboutCompanyPage extends StatelessWidget {
  const AboutCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: Scaffold(
        body: BlocBuilder<AboutCompanyBloc, AboutCompanyState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: AppPopButton(context,
                            onTap: () => context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState())),
                            text: 'О компании', color: Colors.black,
                            textStyle: AppStyle.black16),
                      ),
                    ),
                    Padding(padding:const EdgeInsets.only(top: 10, bottom: 30),
                    child: Image.asset(AppImages.logo, width: size.width - 200, height: size.width - 200,),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 22,
                    ), child: Align(
                        alignment: Alignment.topLeft,
                        child: state.description.isEmpty ? Center(
                          child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator(
                            color: AppColor.firstColor,
                          ),),
                        ) :  Text(state.description, style: AppStyle.black16, overflow: TextOverflow.visible, textAlign: TextAlign.start,)),)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
