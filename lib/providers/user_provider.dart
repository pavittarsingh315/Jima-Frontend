import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nerajima/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  File? _newProfilePicture;
  bool _savedNewProfilePicture = true;

  User get user => _user;
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
}
