import 'package:flutter/material.dart';

import 'package:nerajima/pages/authentication/login.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _runPreAppCheck() async {
      try {
        debugPrint("Ran Pre App Check");
        await Future.delayed(const Duration(seconds: 2));
        return false; // isAuth value
      } catch (e) {
        return Future.error(e);
      }
    }

    return FutureBuilder(
      initialData: null,
      future: _runPreAppCheck(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error connecting to server...')));
        }
        if (snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('Splash Screen')));
        }
        if (snapshot.data == true) {
          return _home(context);
        } else if (snapshot.data == false) {
          return const LoginPage();
        }
        return const Scaffold(body: Center(child: Text('Unknown Error...')));
      },
    );
  }

  Widget _home(BuildContext context) {
    return const Center(
      child: Text(
        "Home Page",
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
