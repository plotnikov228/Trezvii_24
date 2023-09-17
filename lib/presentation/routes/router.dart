import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/presentation/features/chat/chat_page.dart';
import 'package:sober_driver_analog/presentation/features/home/ui/home_page.dart';
import 'package:sober_driver_analog/presentation/features/profile/profile_page.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';

import '../features/add_address_to_favorite/add_address_to_favorite_page.dart';
import '../features/auth/ui/auth_page.dart';
import '../features/auth/ui/widgets/sign_up_page.dart';
import '../features/privacy_policy/privacy_policy_page.dart';
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
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.profile,
            name: AppRoutes.profile,
            builder: (BuildContext context, GoRouterState state) {
              return const ProfilePage();
            },
          ),
          GoRoute(
              path: AppRoutes.addNewAddress,
              name: AppRoutes.addNewAddress,
              builder: (context, state) {
                return const AddAddressToFavoritePage();
              }),
          GoRoute(path: AppRoutes.privacyPolicy,
          name: AppRoutes.privacyPolicy,
            builder: (context, state) {
              return const PrivacyPolicyPage();
            }
          )
        ],
      ),
      GoRoute(
        path: '${AppRoutes.chat}/:chatId',
        name: '${AppRoutes.chat}',
        builder: (BuildContext context, GoRouterState state) {
          return ChatPage(chatId: state.pathParameters['chatId'] ?? '');
        },
      )
    ],
  );
}
