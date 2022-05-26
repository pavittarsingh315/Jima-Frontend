import 'package:flutter/material.dart';

enum Status {
  badAuth,
  authenticating,
  goodAuth,
}

class AuthProvider extends ChangeNotifier {
  Status _authStatus = Status.badAuth;

  Status get authStatus => _authStatus;

  Future<Map<String, dynamic>> tokenAuth() async {
    try {
      debugPrint("Ran Pre App Check");
      _authStatus = Status.authenticating;
      await Future.delayed(const Duration(milliseconds: 250));
      _authStatus = Status.goodAuth;
      return {"authenticated": false};
    } catch (e) {
      _authStatus = Status.badAuth;
      return Future.error(e);
    }
  }
}
