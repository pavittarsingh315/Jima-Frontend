import 'package:flutter/material.dart';

import 'package:nerajima/root.dart';
import 'package:nerajima/trunk.dart';

import 'package:nerajima/pages/authentication/login.dart';
import 'package:nerajima/pages/authentication/registration.dart';
import 'package:nerajima/pages/authentication/verify_registration.dart';
import 'package:nerajima/pages/authentication/request_password_reset.dart';
import 'package:nerajima/pages/authentication/verify_reset_code.dart';
import 'package:nerajima/pages/authentication/reset_password.dart';

import 'package:nerajima/pages/profile/settings.dart';

import 'package:nerajima/pages/profile/edit_profile.dart';
import 'package:nerajima/pages/profile/components/edit/edit_username.dart';
import 'package:nerajima/pages/profile/components/edit/edit_name.dart';
import 'package:nerajima/pages/profile/components/edit/edit_bio.dart';
import 'package:nerajima/pages/profile/components/edit/edit_blacklist_message.dart';

import 'package:nerajima/components/visit_profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    if (settings.name == AppRoot.route) {
      return MaterialPageRoute(builder: (_) => const AppRoot());
    } else if (settings.name == AppTrunk.route) {
      return MaterialPageRoute(builder: (_) => const AppTrunk());
    } else if (settings.name == LoginPage.route) {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    } else if (settings.name == RegistrationPage.route) {
      return MaterialPageRoute(builder: (_) => const RegistrationPage());
    } else if (settings.name == VerifyRegistration.route) {
      if (args == null) return _notEnoughArgs();
      return MaterialPageRoute(
        builder: (_) => VerifyRegistration(
          name: args["name"],
          username: args["username"],
          password: args["password"],
          originalContact: args["originalContact"],
          formattedContact: args["formattedContact"],
        ),
      );
    } else if (settings.name == RequestPasswordReset.route) {
      return MaterialPageRoute(builder: (_) => const RequestPasswordReset());
    } else if (settings.name == VerifyPasswordResetCode.route) {
      if (args == null) return _notEnoughArgs();
      return MaterialPageRoute(builder: (_) => VerifyPasswordResetCode(originalContact: args["originalContact"], formattedContact: args["formattedContact"]));
    } else if (settings.name == ResetPassword.route) {
      if (args == null) return _notEnoughArgs();
      return MaterialPageRoute(builder: (_) => ResetPassword(code: args["code"], contact: args["contact"]));
    } else if (settings.name == SettingsPage.route) {
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    } else if (settings.name == EditProfilePage.route) {
      return MaterialPageRoute(builder: (_) => const EditProfilePage());
    } else if (settings.name == EditUsernamePage.route) {
      return MaterialPageRoute(builder: (_) => const EditUsernamePage());
    } else if (settings.name == EditNamePage.route) {
      return MaterialPageRoute(builder: (_) => const EditNamePage());
    } else if (settings.name == EditBioPage.route) {
      return MaterialPageRoute(builder: (_) => const EditBioPage());
    } else if (settings.name == EditBlacklistMessagePage.route) {
      return MaterialPageRoute(builder: (_) => const EditBlacklistMessagePage());
    } else if (settings.name == VisitProfile.route) {
      if (args == null) return _notEnoughArgs();
      return MaterialPageRoute(builder: (_) => VisitProfile(profileId: args["profileId"]));
    }
    return _notFoundRoute();
  }

  static Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(body: Center(child: Text("Page not found!")));
      },
    );
  }

  static Route<dynamic> _notEnoughArgs() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(body: Center(child: Text("Insufficient arguments provided!")));
      },
    );
  }
}
