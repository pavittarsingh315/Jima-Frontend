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
import 'package:flutter/material.dart' as _i12;

import '../pages/authentication/login.dart' as _i10;
import '../pages/authentication/registration.dart' as _i11;
import '../pages/browse/browse.dart' as _i4;
import '../pages/create/create.dart' as _i5;
import '../pages/home/home.dart' as _i3;
import '../pages/inbox/inbox.dart' as _i6;
import '../pages/profile/edit_profile.dart' as _i9;
import '../pages/profile/profile.dart' as _i7;
import '../pages/profile/settings.dart' as _i8;
import '../root.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
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
    HomeRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    BrowseRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    CreateRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    InboxRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    HomeRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.HomePage());
    },
    BrowseRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.BrowsePage());
    },
    CreateRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.CreatePage());
    },
    InboxRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.InboxPage());
    },
    ProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ProfilePage());
    },
    SettingsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.SettingsPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i9.EditProfilePage());
    },
    LoginRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.LoginPage());
    },
    RegistrationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i11.RegistrationPage());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(AppRoot.name, path: '/', children: [
          _i2.RouteConfig(HomeRouter.name,
              path: 'home',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(HomeRoute.name,
                    path: '', parent: HomeRouter.name)
              ]),
          _i2.RouteConfig(BrowseRouter.name,
              path: 'browse',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(BrowseRoute.name,
                    path: '', parent: BrowseRouter.name)
              ]),
          _i2.RouteConfig(CreateRouter.name,
              path: 'create',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(CreateRoute.name,
                    path: '', parent: CreateRouter.name)
              ]),
          _i2.RouteConfig(InboxRouter.name,
              path: 'inbox',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(InboxRoute.name,
                    path: '', parent: InboxRouter.name)
              ]),
          _i2.RouteConfig(ProfileRouter.name,
              path: 'profile',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(ProfileRoute.name,
                    path: '', parent: ProfileRouter.name),
                _i2.RouteConfig(SettingsRoute.name,
                    path: 'settings', parent: ProfileRouter.name),
                _i2.RouteConfig(EditProfileRoute.name,
                    path: 'edit', parent: ProfileRouter.name)
              ])
        ]),
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
  const AppRoot({List<_i2.PageRouteInfo>? children})
      : super(AppRoot.name, path: '/', initialChildren: children);

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
/// [_i2.EmptyRouterPage]
class HomeRouter extends _i2.PageRouteInfo<void> {
  const HomeRouter({List<_i2.PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class BrowseRouter extends _i2.PageRouteInfo<void> {
  const BrowseRouter({List<_i2.PageRouteInfo>? children})
      : super(BrowseRouter.name, path: 'browse', initialChildren: children);

  static const String name = 'BrowseRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class CreateRouter extends _i2.PageRouteInfo<void> {
  const CreateRouter({List<_i2.PageRouteInfo>? children})
      : super(CreateRouter.name, path: 'create', initialChildren: children);

  static const String name = 'CreateRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class InboxRouter extends _i2.PageRouteInfo<void> {
  const InboxRouter({List<_i2.PageRouteInfo>? children})
      : super(InboxRouter.name, path: 'inbox', initialChildren: children);

  static const String name = 'InboxRouter';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class ProfileRouter extends _i2.PageRouteInfo<void> {
  const ProfileRouter({List<_i2.PageRouteInfo>? children})
      : super(ProfileRouter.name, path: 'profile', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i2.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.BrowsePage]
class BrowseRoute extends _i2.PageRouteInfo<void> {
  const BrowseRoute() : super(BrowseRoute.name, path: '');

  static const String name = 'BrowseRoute';
}

/// generated route for
/// [_i5.CreatePage]
class CreateRoute extends _i2.PageRouteInfo<void> {
  const CreateRoute() : super(CreateRoute.name, path: '');

  static const String name = 'CreateRoute';
}

/// generated route for
/// [_i6.InboxPage]
class InboxRoute extends _i2.PageRouteInfo<void> {
  const InboxRoute() : super(InboxRoute.name, path: '');

  static const String name = 'InboxRoute';
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i2.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i2.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i9.EditProfilePage]
class EditProfileRoute extends _i2.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: 'edit');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i10.LoginPage]
class LoginRoute extends _i2.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i11.RegistrationPage]
class RegistrationRoute extends _i2.PageRouteInfo<void> {
  const RegistrationRoute() : super(RegistrationRoute.name, path: 'register');

  static const String name = 'RegistrationRoute';
}
