import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/splash/bloc/event.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';

import '../../../utils/size_util.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            SplashBloc(SplashState())..add(InitializeAppInSplashEvent(context)),
        child: Scaffold(body: BlocBuilder<SplashBloc, SplashState>(
            builder: (BuildContext context, state) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.firstColor, Colors.white])),
            child: Center(
              child: Image.asset(AppImages.logo, width: size.width - 100, height: size.width - 100,),
            ),
          );
        })));
  }
}
