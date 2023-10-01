import 'package:flutter/material.dart';
import 'package:sober_driver_analog/l10n/all_locales.dart';
import 'package:sober_driver_analog/presentation/routes/router.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

final _router = AppRouter().router;

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    /*supportedLocales: AllLocale.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],*/
      title: 'Трезвый 24',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.firstColor),
        useMaterial3: true,
      ),
    );
  }
}