// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i6;

import '../pages/authentication/login.dart' as _i4;
import '../pages/authentication/registration.dart' as _i5;
import '../root.dart' as _i1;
import '../trunk.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    AppRoot.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.AppRoot());
    },
    AppTrunk.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.AppTrunk());
    },
    AuthRouter.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    LoginRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.LoginPage());
    },
    RegistrationRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.RegistrationPage());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(AppRoot.name, path: '/'),
        _i3.RouteConfig(AppTrunk.name, path: '/trunk'),
        _i3.RouteConfig(AuthRouter.name, path: '/authentication', children: [
          _i3.RouteConfig(LoginRoute.name,
              path: 'login', parent: AuthRouter.name),
          _i3.RouteConfig(RegistrationRoute.name,
              path: 'register', parent: AuthRouter.name)
        ])
      ];
}

/// generated route for
/// [_i1.AppRoot]
class AppRoot extends _i3.PageRouteInfo<void> {
  const AppRoot() : super(AppRoot.name, path: '/');

  static const String name = 'AppRoot';
}

/// generated route for
/// [_i2.AppTrunk]
class AppTrunk extends _i3.PageRouteInfo<void> {
  const AppTrunk() : super(AppTrunk.name, path: '/trunk');

  static const String name = 'AppTrunk';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class AuthRouter extends _i3.PageRouteInfo<void> {
  const AuthRouter({List<_i3.PageRouteInfo>? children})
      : super(AuthRouter.name,
            path: '/authentication', initialChildren: children);

  static const String name = 'AuthRouter';
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i3.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i5.RegistrationPage]
class RegistrationRoute extends _i3.PageRouteInfo<void> {
  const RegistrationRoute() : super(RegistrationRoute.name, path: 'register');

  static const String name = 'RegistrationRoute';
}
