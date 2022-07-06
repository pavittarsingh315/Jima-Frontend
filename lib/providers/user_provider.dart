import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'package:nerajima/models/user_model.dart';
import 'package:nerajima/utils/api_endpoints.dart';

enum UserStatus {
  nil,
  updating,
  uploading,
}

class UserProvider extends ChangeNotifier {
  late User _user;
  late Map<String, String> _requestHeaders;
  late FlutterUploader _uploader;
  UserStatus _userStatus = UserStatus.nil;
  File? _newProfilePicture;
  bool _savedNewProfilePicture = true;
  int imgIndex = 0;

  User get user => _user;
  UserStatus get userStatus => _userStatus;
  File? get newProfilePicture => _newProfilePicture;
  bool get savedNewProfilePicture => _savedNewProfilePicture;
  Map<String, String> get requestHeaders => _requestHeaders;

  void setUser(User user) {
    _user = user;
    _requestHeaders = {'Content-Type': "application/json", 'Token': _user.access, 'UserId': _user.userId};
    _uploader = FlutterUploader();
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

  void incrementFollowing() {
    _user.numFollowing++;
    notifyListeners();
  }

  void decrementFollowing() {
    _user.numFollowing--;
    notifyListeners();
  }

  void incrementWhitelisted() {
    _user.numWhitelisted++;
    notifyListeners();
  }

  void decrementWhitelisted() {
    _user.numWhitelisted--;
    notifyListeners();
  }

  void decrementFollowers() {
    _user.numFollowers--;
    notifyListeners();
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> changeProfilePicture() async {
    try {
      _userStatus = UserStatus.uploading;
      notifyListeners();

      final url = Uri.parse(ApiEndpoints.getProfilePicUploadUrl);
      Response response = await get(url, headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        var largeUploadUrl = resData["data"]["data"]["largeUploadUrl"];
        var miniUploadUrl = resData["data"]["data"]["miniUploadUrl"];
        var largeFileUrl = resData["data"]["data"]["largeFileUrl"];
        var miniFileUrl = resData["data"]["data"]["miniFileUrl"];

        var largeFile = await _resizeImage(_newProfilePicture!.absolute.path, 1100, 1100);
        var miniFile = await _resizeImage(_newProfilePicture!.absolute.path, 200, 200);
        if (largeFile == null || miniFile == null) {
          throw Exception("Something went wrong updating the profile picture...");
        }

        await _uploader.clearUploads();
        await _uploader.enqueue(
          RawUpload(
            url: largeUploadUrl,
            method: UploadMethod.PUT,
            headers: {"Content-Type": "image/jpeg"},
            path: largeFile.path,
          ),
        );
        await _uploader.enqueue(
          RawUpload(
            url: miniUploadUrl,
            method: UploadMethod.PUT,
            headers: {"Content-Type": "image/jpeg"},
            path: miniFile.path,
          ),
        );

        // since image is now resized and easily portable, it won't take long to send image.
        // this delay is to add a buffer to really make sure the image is sent.
        await Future.delayed(const Duration(milliseconds: 200));

        final reqBody = {"newProfilePicture": largeFileUrl, "newMiniProfilePicture": miniFileUrl, "oldProfilePicture": _user.profilePicture};
        final url = Uri.parse(ApiEndpoints.editProfilePicture);
        Response response = await put(url, body: convert.jsonEncode(reqBody), headers: _requestHeaders);
        final Map<String, dynamic> resData2 = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

        largeFile.deleteSync();
        miniFile.deleteSync();

        if (resData2["message"] == "Success") {
          _userStatus = UserStatus.nil;
          _savedNewProfilePicture = true;
          _user.profilePicture = largeFileUrl;
          _user.miniProfilePicture = miniFileUrl;
          notifyListeners();
          return {"status": true};
        } else if (resData2["message"] == "Error") {
          return {"status": false, "message": resData2["data"]["data"]};
        }
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

  Future<File?> _resizeImage(String filePath, int height, int width) async {
    // final stopwatch = Stopwatch()..start(); // uncomment to print exec. time of function
    Directory tempDir = await getTemporaryDirectory();
    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      "${tempDir.path}/resized$imgIndex.jpeg",
      minHeight: height,
      minWidth: width,
      format: CompressFormat.jpeg,
    );
    imgIndex++;
    // stopwatch.stop(); // uncomment to print exec. time of function
    // print('Executed in ${stopwatch.elapsed.inMilliseconds}'); // uncomment to print exec. time of function
    return result;
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> followUser({required String profileId}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.followAUser}/$profileId");
      Response response = await post(url, headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        incrementFollowing();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong following the name...");
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> unfollowUser({required String profileId}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.unfollowAUser}/$profileId");
      Response response = await delete(url, headers: _requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        decrementFollowing();
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong unfollowing the name...");
    } catch (e) {
      return Future.error(e);
    }
  }
}
