import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/home_page.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';

import '../features/auth/ui/auth_page.dart';
import '../features/auth/ui/widgets/sign_up_page.dart';
import '../features/splash/ui/splash_page.dart';
import '../features/tutorial/ui/tutorial_page.dart';

class AppRouter {
  Future<String> getStartLocation(bool authorized) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('tutorial was completed') ?? false)
        ? authorized
            ? AppRoutes.home
            : AppRoutes.auth
        : AppRoutes.tutorial;
  }

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.tutorial,
        name: AppRoutes.tutorial,
        builder: (BuildContext context, GoRouterState state) {
          return const TutorialPage();
        },
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: AppRoutes.auth,
        builder: (BuildContext context, GoRouterState state) {
          return AuthPage();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[],
      ),
    ],
  );
}
