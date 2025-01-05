import 'package:bloc_clean_architecture/presentation/pages/user/users_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/auth/sign_in_screen.dart';
import '../../presentation/pages/auth/sign_up_screen.dart';
import '../../presentation/pages/dashboard/dashboard_screen.dart';
import '../../presentation/pages/error/error_screen.dart';
import '../../presentation/pages/splash/splash_screen.dart';
import '../config/routes.dart';
import 'logger.dart';

GoRouter routerInit = GoRouter(
  routes: <RouteBase>[
    ///  =================================================================
    ///  ********************** Splash Route *****************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.splashRouteName,
      path: AppRoutes.splashRoutePath,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    ///  =================================================================
    /// ********************** Authentication Routes ********************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.loginRouteName,
      path: AppRoutes.loginRoutePath,
      builder: (BuildContext context, GoRouterState state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      name: AppRoutes.signupRouteName,
      path: AppRoutes.signupRoutePath,
      builder: (BuildContext context, GoRouterState state) {
        return const SignUnPage();
      },
    ),

    ///  =================================================================
    /// ********************** DashBoard Route ******************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.dashboardRouteName,
      path: AppRoutes.dashboardRoutePath,
      builder: (BuildContext context, GoRouterState state) {
        return const DashBoardScreen();
      },
    ),

    ///  =================================================================
    /// ********************** Users Route ******************************
    /// ==================================================================

    GoRoute(
      name: AppRoutes.usersRouteName,
      path: AppRoutes.usersRoutePath,
      builder: (BuildContext context, GoRouterState state) {
        return const UsersPage();
      },
    ),
  ],
  errorPageBuilder: (context, state) {
    return const MaterialPage(child: ErrorScreen());
  },
  redirect: (context, state) {
    logger.info('redirect: ${state.uri}');
    return null;
  },
);
