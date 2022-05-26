import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/models/user_model.dart';
import 'package:nerajima/utils/api_endpoints.dart';

enum Status {
  badAuth,
  authenticating,
  goodAuth,
}

class AuthProvider extends ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  Status _authStatus = Status.badAuth;

  Status get authStatus => _authStatus;

  /// Success map keys: [status, user]. Error map keys: [status].
  Future<Map<String, dynamic>> tokenAuth() async {
    try {
      debugPrint("Ran Pre App Check");

      _authStatus = Status.authenticating;
      Map<String, String> store = await _secureStorage.readAll();
      if (store['access'] == null || store['refresh'] == null) {
        _authStatus = Status.badAuth;
        return {"status": false};
      }

      final reqBody = {"access": store['access'], "refresh": store['refresh']};
      final url = Uri.parse(ApiEndpoints.tokenLogin);
      Response response = await post(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(response.body);

      if (resData["message"] == "Success") {
        User user = User.fromJson(resData["data"]["data"]);

        _authStatus = Status.goodAuth;
        return {"status": true, "user": user};
      } else if (resData["message"] == "Error") {
        await _secureStorage.deleteAll();

        _authStatus = Status.badAuth;
        return {"status": false};
      }

      throw Exception("Something went wrong with the pre app check...");
    } catch (e) {
      _authStatus = Status.badAuth;
      return Future.error(e);
    }
  }

  /// Success map keys: [status, user]. Error map keys: [status, message].
  Future<Map<String, dynamic>> loginAuth({required String contact, required String password}) async {
    try {
      _authStatus = Status.authenticating;
      notifyListeners();

      final reqBody = {"contact": contact, "password": password};
      final url = Uri.parse(ApiEndpoints.login);
      Response response = await post(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(response.body);

      if (resData["message"] == "Success") {
        User user = User.fromJson(resData["data"]["data"]);

        await _secureStorage.write(key: "access", value: user.access);
        await _secureStorage.write(key: "refresh", value: user.refresh);

        _authStatus = Status.goodAuth;
        notifyListeners();
        return {"status": true, "user": user};
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

  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: "access");
      await _secureStorage.delete(key: "refresh");
    } catch (e) {
      return Future.error(e);
    }
  }
}
