import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../classes/hoopup_user.dart';

final hoopUpUserProvider = ChangeNotifierProvider<HoopUpUserProvider>((ref) {
  return HoopUpUserProvider();
});

class HoopUpUserProvider extends ChangeNotifier {
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
