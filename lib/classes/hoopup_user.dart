import 'package:firebase_database/firebase_database.dart';
import 'event.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class HoopUpUser {
  String _username;
  int _skillLevel;
  final String _id;
  final List<Event> _events = [];
  String? _photoUrl;

  HoopUpUser(
      {required String username,
      required int skillLevel,
      required String id,
      required String? photoUrl})
      : _username = username,
        _skillLevel = skillLevel,
        _id = id,
        _photoUrl = photoUrl {
    _validateSkillLevel(skillLevel);
    database.ref("users/$_id").set({
      "username": _username,
      "skillLevel": _skillLevel,
      "photoUrl": _photoUrl,
    }).catchError((error) {
      print("Failed to create user: ${error.toString()}");
    });
  }

  // setters

  set photo(String url) {
    _photoUrl = url;
    database
        .ref("users/$_id")
        .update({"photoUrl": _photoUrl}).catchError((error) {
      print("Failed to update photo: ${error.toString()}");
    });
  }

  set username(String username) {
    _username = username;
    database
        .ref("users/$_id")
        .update({"username": _username}).catchError((error) {
      print("Failed to update username: ${error.toString()}");
    });
  }

  set skillLevel(int skillLevel) {
    _validateSkillLevel(skillLevel);
    _skillLevel = skillLevel;
    database
        .ref("users/$_id")
        .update({"skillLevel": _skillLevel}).catchError((error) {
      print("Failed to update skill level: ${error.toString()}");
    });
  }

  // getters

  String? get photoUrl => _photoUrl;

  String get username => _username;

  List<Event> get events => _events;

  String get id => _id;

  int get skillLevel => _skillLevel;
   Map<String, dynamic> toJson() {
    return {'username': _username, 'skillLevel': _skillLevel, 'id': _id, 'photoUrl': _photoUrl };
  }

  // handle events

  void addEvent(Event event) {
    String id = event.id;
    _events.add(event);
    database
        .ref("users/$_id/events/$id")
        .set(event.toJson())
        .catchError((error) {
      print("Failed to add event: ${error.toString()}");
    });
  }

  void removeEvent(Event event) {
    int index = _events.indexOf(event);
    if (index >= 0) {
      _events.removeAt(index);
      database
          .ref("users/$_id/events/${event.id}")
          .remove()
          .catchError((error) {
        print("Failed to remove event: ${error.toString()}");
      });
    }
  }

  @override
  String toString() => 'User: $_username, $_skillLevel, $_id';

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
      var user = _auth.currentUser;
      await user?.delete();
      database.ref("users/$_id").remove();
      print("User deleted successfully");
    } catch (e) {
      print("Failed to delete user: ${e.toString()}");
    }
  }

  static bool isUserSignedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
