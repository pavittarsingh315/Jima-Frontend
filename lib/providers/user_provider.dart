import 'package:flutter/material.dart';

import 'package:nerajima/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
