import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/models/user_model.dart';
import 'package:nerajima/utils/api_endpoints.dart';

enum UserStatus {
  nil,
  updating,
}

class UserProvider extends ChangeNotifier {
  late User _user;
  UserStatus _userStatus = UserStatus.nil;
  File? _newProfilePicture;
  bool _savedNewProfilePicture = true;

  User get user => _user;
  UserStatus get userStatus => _userStatus;
  File? get newProfilePicture => _newProfilePicture;
  bool get savedNewProfilePicture => _savedNewProfilePicture;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setNewProfilePicture({required File newProfilePicture}) {
    _newProfilePicture = newProfilePicture;
    _savedNewProfilePicture = false;
    notifyListeners();
  }

  void clearNewProfilePicture() {
    _newProfilePicture = null;
    _savedNewProfilePicture = true;
    notifyListeners();
  }

  Future<void> changeProfilePicture() async {
    // use _newProfilePicture to do API call
    _savedNewProfilePicture = true;
    notifyListeners();
  }

  Future<Map<String, dynamic>> changeUsername({required String username}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"username": username};
      final url = Uri.parse(ApiEndpoints.editUsername);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the username...");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> changeName({required String name}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"name": name};
      final url = Uri.parse(ApiEndpoints.editName);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the name...");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> changeBio({required String bio}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"bio": bio};
      final url = Uri.parse(ApiEndpoints.editBio);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the name...");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> changeBlacklistMessage({required String blacklistMessage}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"blacklistMessage": blacklistMessage};
      final url = Uri.parse(ApiEndpoints.editBlacklistMessage);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: {'Content-Type': "application/json"});
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the name...");
    } catch (e) {
      return Future.error(e);
    }
  }
}
