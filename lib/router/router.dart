import 'package:auto_route/auto_route.dart';

import 'package:nerajima/root.dart';

import 'package:nerajima/pages/authentication/login.dart';
import 'package:nerajima/pages/authentication/registration.dart';

// Run this command to auto generate the code for the routing. Rerun the command if you make any changes.
// If you keep making changes, you can replace "build" with "watch"
// flutter pub run build_runner build --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route', // Replaces the 'Page' part of widget's name with 'Router'
  routes: [
    AutoRoute(
      path: '/',
      page: AppRoot,
    ),
    AutoRoute(
      path: "/authentication",
      name: "AuthRouter",
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: "login",
          page: LoginPage,
        ),
        AutoRoute(
          path: "register",
          page: RegistrationPage,
        ),
      ],
    )
  ],
)
class $AppRouter {}
