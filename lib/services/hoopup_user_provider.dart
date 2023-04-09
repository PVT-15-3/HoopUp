import '../classes/hoopup_user.dart';
import 'package:flutter/material.dart';

class HoopUpUserProvider extends ChangeNotifier {
  HoopUpUser? _user;

  void setUser(HoopUpUser user) {
    _user = user;
    notifyListeners();
  }

  HoopUpUser? get user => _user;
}
