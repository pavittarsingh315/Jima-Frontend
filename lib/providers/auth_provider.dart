import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';

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

  Future<Map<String, dynamic>> loginAuth({required String contact, required String password}) async {
    try {
      _authStatus = Status.authenticating;
      notifyListeners();

      final reqBody = {"contact": contact, "password": password};
      final url = Uri.parse(ApiEndpoints.login);
      Response response = await post(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(response.body);

      if (resData["message"] == "Success") {
        var userData = resData["data"]["data"]; // convert to User model

        _authStatus = Status.goodAuth;
        notifyListeners();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        _authStatus = Status.badAuth;
        notifyListeners();
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong logging in...");
    } catch (e) {
      _authStatus = Status.badAuth;
      notifyListeners();
      return Future.error(e);
    }
  }
}
