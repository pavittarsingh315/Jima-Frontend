import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/utils/custom_dialog.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<void> _onLogoutPress() async {
      showDialog(
        context: context,
        builder: (context) {
          void cancel() {
            Navigator.of(context).pop();
          }

          Future<void> logout() async {
            await authProvider.logout();
            context.router.root.pushAndPopUntil(
              const AuthRouter(children: [LoginRoute()]),
              predicate: (Route<dynamic> router) => false,
            );
          }

          return CustomDialog(
            message: "Are you sure you want to logout?",
            actionLabels: const ["Cancel", "Logout"],
            actionCallbacks: [cancel, logout],
            actionColors: const [Colors.blue, Colors.red],
            topPadding: 45,
          );
        },
      );
    }

    return PillButton(
      onTap: _onLogoutPress,
      color: Colors.red,
      margin: 0,
      child: const Text(
        "Logout",
        textAlign: TextAlign.center,
      ),
    );
  }
}
