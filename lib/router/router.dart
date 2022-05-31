import 'package:auto_route/auto_route.dart';

import 'package:nerajima/root.dart';

import 'package:nerajima/pages/authentication/login.dart';
import 'package:nerajima/pages/authentication/registration.dart';

import 'package:nerajima/pages/home/home.dart';
import 'package:nerajima/pages/browse/browse.dart';
import 'package:nerajima/pages/create/create.dart';
import 'package:nerajima/pages/inbox/inbox.dart';

import 'package:nerajima/pages/profile/profile.dart';
import 'package:nerajima/pages/profile/settings.dart';
import 'package:nerajima/pages/profile/edit_profile.dart';
import 'package:nerajima/pages/profile/components/edit/edit_username.dart';
import 'package:nerajima/pages/profile/components/edit/edit_name.dart';
import 'package:nerajima/pages/profile/components/edit/edit_bio.dart';
import 'package:nerajima/pages/profile/components/edit/edit_blacklist_message.dart';

// Run this command to auto generate the code for the routing. Rerun the command if you make any changes.
// If you keep making changes, you can replace "build" with "watch"
// flutter pub run build_runner build --delete-conflicting-outputs

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route', // Replaces the 'Page' part of widget's name with 'Router'
  routes: [
    AutoRoute(
      path: '/',
      page: AppRoot,
      children: [
        AutoRoute(
          path: 'home',
          name: 'HomeRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: HomePage,
            ),
          ],
        ),
        AutoRoute(
          path: 'browse',
          name: 'BrowseRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: BrowsePage,
            ),
          ],
        ),
        AutoRoute(
          path: 'create',
          name: 'CreateRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: CreatePage,
            ),
          ],
        ),
        AutoRoute(
          path: 'inbox',
          name: 'InboxRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: InboxPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'profile',
          name: 'ProfileRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: ProfilePage,
            ),
            AutoRoute(
              path: 'settings',
              page: SettingsPage,
            ),
            AutoRoute(
              path: 'edit',
              name: 'EditRouter',
              page: EmptyRouterPage,
              children: [
                AutoRoute(
                  path: '',
                  page: EditProfilePage,
                ),
                AutoRoute(
                  path: 'username',
                  page: EditUsernamePage,
                ),
                AutoRoute(
                  path: 'name',
                  page: EditNamePage,
                ),
                AutoRoute(
                  path: 'bio',
                  page: EditBioPage,
                ),
                AutoRoute(
                  path: 'blacklistMessage',
                  page: EditBlacklistMessagePage,
                ),
              ],
            )
          ],
        ),
      ],
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
