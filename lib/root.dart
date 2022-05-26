import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/trunk.dart';
import 'package:nerajima/pages/authentication/login.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<bool> _runPreAppCheck() async {
      try {
        Map<String, dynamic> response = await authProvider.tokenAuth();
        return response["authenticated"];
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
          return const AppTrunk();
        } else if (snapshot.data == false) {
          return const LoginPage();
        }
        return const Scaffold(body: Center(child: Text('Unknown Error...')));
      },
    );
  }
}
