import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:nerajima/models/user_model.dart';
import 'package:nerajima/utils/api_endpoints.dart';

enum UserStatus {
  nil,
  updating,
  gettingUrl,
  uploading,
}

class UserProvider extends ChangeNotifier {
  late User _user;
  late Map<String, String> _requestHeaders;
  UserStatus _userStatus = UserStatus.nil;
  File? _newProfilePicture;
  bool _savedNewProfilePicture = true;

  User get user => _user;
  UserStatus get userStatus => _userStatus;
  File? get newProfilePicture => _newProfilePicture;
  bool get savedNewProfilePicture => _savedNewProfilePicture;

  void setUser(User user) {
    _user = user;
    _requestHeaders = {'Content-Type': "application/json", 'Token': _user.access, 'UserId': _user.userId};
    FlutterUploader().setBackgroundHandler(backgroundHandler);
    notifyListeners();
  }

  static void backgroundHandler() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterUploader uploader = FlutterUploader();
    uploader.progress.listen((progress) {});
    uploader.result.listen((result) {});
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

  Future<Map<String, dynamic>> changeProfilePicture() async {
    try {
      _userStatus = UserStatus.gettingUrl;
      notifyListeners();

      final url = Uri.parse(ApiEndpoints.getProfilePicUploadUrl);
      Response response = await get(url, headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        var uploadUrl = resData["data"]["data"]["uploadUrl"];
        var fileUrl = resData["data"]["data"]["fileUrl"];

        _userStatus = UserStatus.uploading;
        notifyListeners();

        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the profile picture...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> changeUsername({required String newUsername}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"username": newUsername};
      final url = Uri.parse(ApiEndpoints.editUsername);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        _user.username = newUsername;
        notifyListeners();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the username...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> changeName({required String newName}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"name": newName};
      final url = Uri.parse(ApiEndpoints.editName);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        _user.name = newName;
        notifyListeners();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the name...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> changeBio({required String newBio}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"bio": newBio};
      final url = Uri.parse(ApiEndpoints.editBio);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        _user.bio = newBio;
        notifyListeners();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong updating the name...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> changeBlacklistMessage({required String newBlacklistMessage}) async {
    try {
      _userStatus = UserStatus.updating;
      notifyListeners();

      final reqBody = {"blacklistMessage": newBlacklistMessage};
      final url = Uri.parse(ApiEndpoints.editBlacklistMessage);
      Response response = await put(url, body: convert.jsonEncode(reqBody), headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      _userStatus = UserStatus.nil;
      notifyListeners();

      if (resData["message"] == "Success") {
        if (newBlacklistMessage == "" && _user.blacklistMessage != defaultBlacklistMessage) {
          _user.blacklistMessage = defaultBlacklistMessage;
        } else {
          _user.blacklistMessage = newBlacklistMessage;
        }
        notifyListeners();
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
