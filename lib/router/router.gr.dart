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
import 'package:flutter/material.dart' as _i14;

import '../pages/authentication/login.dart' as _i12;
import '../pages/authentication/registration.dart' as _i13;
import '../pages/home/home.dart' as _i3;
import '../pages/inbox/inbox.dart' as _i4;
import '../pages/profile/components/edit/edit_bio.dart' as _i10;
import '../pages/profile/components/edit/edit_blacklist_message.dart' as _i11;
import '../pages/profile/components/edit/edit_name.dart' as _i9;
import '../pages/profile/components/edit/edit_username.dart' as _i8;
import '../pages/profile/edit_profile.dart' as _i7;
import '../pages/profile/profile.dart' as _i5;
import '../pages/profile/settings.dart' as _i6;
import '../root.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
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
    InboxRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.InboxPage());
    },
    ProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.ProfilePage());
    },
    SettingsRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.SettingsPage());
    },
    EditRouter.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    EditProfileRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.EditProfilePage());
    },
    EditUsernameRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i8.EditUsernamePage());
    },
    EditNameRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i9.EditNamePage());
    },
    EditBioRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EditBioPage());
    },
    EditBlacklistMessageRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i11.EditBlacklistMessagePage());
    },
    LoginRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i12.LoginPage());
    },
    RegistrationRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.RegistrationPage());
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(AppRoot.name, path: '/', children: [
          _i2.RouteConfig('#redirect',
              path: '',
              parent: AppRoot.name,
              redirectTo: 'home',
              fullMatch: true),
          _i2.RouteConfig(HomeRouter.name,
              path: 'home',
              parent: AppRoot.name,
              children: [
                _i2.RouteConfig(HomeRoute.name,
                    path: '', parent: HomeRouter.name)
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
                _i2.RouteConfig(EditRouter.name,
                    path: 'edit',
                    parent: ProfileRouter.name,
                    children: [
                      _i2.RouteConfig(EditProfileRoute.name,
                          path: '', parent: EditRouter.name),
                      _i2.RouteConfig(EditUsernameRoute.name,
                          path: 'username', parent: EditRouter.name),
                      _i2.RouteConfig(EditNameRoute.name,
                          path: 'name', parent: EditRouter.name),
                      _i2.RouteConfig(EditBioRoute.name,
                          path: 'bio', parent: EditRouter.name),
                      _i2.RouteConfig(EditBlacklistMessageRoute.name,
                          path: 'blacklistMessage', parent: EditRouter.name)
                    ])
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
/// [_i4.InboxPage]
class InboxRoute extends _i2.PageRouteInfo<void> {
  const InboxRoute() : super(InboxRoute.name, path: '');

  static const String name = 'InboxRoute';
}

/// generated route for
/// [_i5.ProfilePage]
class ProfileRoute extends _i2.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: '');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i6.SettingsPage]
class SettingsRoute extends _i2.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class EditRouter extends _i2.PageRouteInfo<void> {
  const EditRouter({List<_i2.PageRouteInfo>? children})
      : super(EditRouter.name, path: 'edit', initialChildren: children);

  static const String name = 'EditRouter';
}

/// generated route for
/// [_i7.EditProfilePage]
class EditProfileRoute extends _i2.PageRouteInfo<void> {
  const EditProfileRoute() : super(EditProfileRoute.name, path: '');

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i8.EditUsernamePage]
class EditUsernameRoute extends _i2.PageRouteInfo<void> {
  const EditUsernameRoute() : super(EditUsernameRoute.name, path: 'username');

  static const String name = 'EditUsernameRoute';
}

/// generated route for
/// [_i9.EditNamePage]
class EditNameRoute extends _i2.PageRouteInfo<void> {
  const EditNameRoute() : super(EditNameRoute.name, path: 'name');

  static const String name = 'EditNameRoute';
}

/// generated route for
/// [_i10.EditBioPage]
class EditBioRoute extends _i2.PageRouteInfo<void> {
  const EditBioRoute() : super(EditBioRoute.name, path: 'bio');

  static const String name = 'EditBioRoute';
}

/// generated route for
/// [_i11.EditBlacklistMessagePage]
class EditBlacklistMessageRoute extends _i2.PageRouteInfo<void> {
  const EditBlacklistMessageRoute()
      : super(EditBlacklistMessageRoute.name, path: 'blacklistMessage');

  static const String name = 'EditBlacklistMessageRoute';
}

/// generated route for
/// [_i12.LoginPage]
class LoginRoute extends _i2.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i13.RegistrationPage]
class RegistrationRoute extends _i2.PageRouteInfo<void> {
  const RegistrationRoute() : super(RegistrationRoute.name, path: 'register');

  static const String name = 'RegistrationRoute';
}
