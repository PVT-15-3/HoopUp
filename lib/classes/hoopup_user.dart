import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/providers/firebase_provider.dart';

class HoopUpUser {
  String _username;
  int _skillLevel;
  final String _id;
  List<String> _events = [];
  String _photoUrl;
  String _gender;
  DateTime _dateOfBirth;
  final FirebaseProvider _firebaseProvider;

  HoopUpUser(
      {required String username,
      required int skillLevel,
      required String id,
      required String photoUrl,
      required String gender,
      required DateTime dateOfBirth,
      required FirebaseProvider firebaseProvider})
      : _username = username,
        _firebaseProvider = firebaseProvider,
        _skillLevel = skillLevel,
        _id = id,
        _photoUrl = photoUrl,
        _dateOfBirth = dateOfBirth,
        _gender = gender {
    _validateSkillLevel(skillLevel);
  }

  void addUserToDatabase() async {
    await _firebaseProvider.setFirebaseDataMap("users/$id", {
      "username": _username,
      "skillLevel": _skillLevel,
      "photoUrl": _photoUrl,
      "gender": _gender,
      "dateOfBirth": _dateOfBirth.millisecondsSinceEpoch,
    });
  }

  // setters

  set photoUrl(String url) {
    _photoUrl = url;
    _firebaseProvider.updateFirebaseData("users/$id", {"photoUrl": url});
  }

  set gender(String gender) {
    _gender = gender;
    _firebaseProvider.updateFirebaseData("users/$id", {"gender": gender});
  }

  set username(String username) {
    _username = username;
    _firebaseProvider.updateFirebaseData("users/$id", {"username": username});
  }

  set skillLevel(int skillLevel) {
    _validateSkillLevel(skillLevel);
    _skillLevel = skillLevel;
    _firebaseProvider
        .updateFirebaseData("users/$id", {"skillLevel": skillLevel});
  }

  set events(List<String> events) {
    _events = events;
    _firebaseProvider.setFirebaseDataList('users/$id/events', events);
  }

  set dateOfBirth(DateTime dateOfBirth) {
    _dateOfBirth = dateOfBirth;
    _firebaseProvider.updateFirebaseData("users/$id", {"dateOfBirth": dateOfBirth});
  }

  // getters

  String get photoUrl => _photoUrl;
  String get gender => _gender;
  String get username => _username;
  List<String> get events => _events;
  String get id => _id;
  int get skillLevel => _skillLevel;
  DateTime get dateOfBirth => _dateOfBirth;

  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'gender': _gender,
      'skillLevel': _skillLevel,
      'id': _id,
      'photoUrl': _photoUrl
    };
  }

  @override
  String toString() =>
      'User: $username, $gender, $skillLevel, $id, $photoUrl, $events';

  // override equality operator

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is HoopUpUser && _id == other._id;
  }

  @override
  int get hashCode => _username.hashCode ^ _skillLevel.hashCode ^ _id.hashCode;

  // validate inputs

  void _validateSkillLevel(int skillLevel) {
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level must be between 0 and 5');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseProvider.removeFirebaseData("users/$id");
      await FirebaseAuth.instance.currentUser?.delete();
      await signOut();
      debugPrint("User deleted successfully");
    } catch (e) {
      debugPrint("Failed to delete user: ${e.toString()}");
    }
  }

  // static methods

  static bool isSignedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
