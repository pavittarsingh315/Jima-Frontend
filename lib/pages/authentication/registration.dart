import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text(
            "Registration Page",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
