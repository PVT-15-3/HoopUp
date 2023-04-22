import 'package:flutter/material.dart';
import '../classes/hoopup_user.dart';

class HoopUpUserProvider with ChangeNotifier {
  HoopUpUser? _user;

  HoopUpUser? get user => _user;

  void setUser(HoopUpUser user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    if (_user != null) {
      _user = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    clearUser();
    super.dispose();
  }
}