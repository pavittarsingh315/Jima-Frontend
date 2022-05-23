import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:nerajima/router/router.gr.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.pushRoute(
              const AuthRouter(
                children: [
                  RegistrationRoute(),
                ],
              ),
            );
            context.router.pop();
          },
          child: const Text(
            "Login Page",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
