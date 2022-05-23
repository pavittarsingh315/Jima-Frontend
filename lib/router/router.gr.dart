// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i5;

import '../pages/authentication/login.dart' as _i3;
import '../pages/authentication/registration.dart' as _i4;
import '../root.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    AppRoot.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.AppRoot());
    },
    AuthRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    LoginRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.LoginPage());
    },
    RegistrationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.RegistrationPage());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(AppRoot.name, path: '/'),
        _i2.RouteConfig(AuthRouter.name, path: '/authentication', children: [
          _i2.RouteConfig(LoginRoute.name,
              path: 'login', parent: AuthRouter.name),
          _i2.RouteConfig(RegistrationRoute.name,
              path: 'register', parent: AuthRouter.name)
        ])
      ];
}

/// generated route for
/// [_i1.AppRoot]
class AppRoot extends _i2.PageRouteInfo<void> {
  const AppRoot() : super(AppRoot.name, path: '/');

  static const String name = 'AppRoot';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class AuthRouter extends _i2.PageRouteInfo<void> {
  const AuthRouter({List<_i2.PageRouteInfo>? children})
      : super(AuthRouter.name,
            path: '/authentication', initialChildren: children);

  static const String name = 'AuthRouter';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i2.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.RegistrationPage]
class RegistrationRoute extends _i2.PageRouteInfo<void> {
  const RegistrationRoute() : super(RegistrationRoute.name, path: 'register');

  static const String name = 'RegistrationRoute';
}
