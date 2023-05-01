import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../handlers/firebase_handler.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HoopUpUser {
  String _username;
  int _skillLevel;
  final String _id;
  List<String> _events = [];
  String? _photoUrl;
  String? _gender; // can be "other", "male", "female"

  HoopUpUser(
      {required String username,
      required int skillLevel,
      required String id,
      required String? photoUrl,
      required String? gender})
      : _username = username,
        _skillLevel = skillLevel,
        _id = id,
        _photoUrl = photoUrl,
        _gender = gender {
    _validateSkillLevel(skillLevel);
  }

  void addUserToDatabase() async {
    await setFirebaseDataMap("users/$id", {
      "username": _username,
      "skillLevel": _skillLevel,
      "photoUrl": _photoUrl,
      "gender": _gender
    });
  }

  // setters

  set photoUrl(String? url) {
    _photoUrl = url;
    updateFirebaseData("users/$id", {"photoUrl": url});
  }

  set gender(String? gender) {
    _gender = gender;
    updateFirebaseData("users/$id", {"gender": gender});
  }

  set username(String username) {
    _username = username;
    updateFirebaseData("users/$id", {"username": username});
  }

  set skillLevel(int skillLevel) {
    _validateSkillLevel(skillLevel);
    _skillLevel = skillLevel;
    updateFirebaseData("users/$id", {"skillLevel": skillLevel});
  }

  set events(List<String> events) {
    _events = events;
    setFirebaseDataList('users/$id/events', events);
  }

  // getters

  String? get photoUrl => _photoUrl;

  String? get gender => _gender;

  String get username => _username;

  List<String> get events => _events;

  String get id => _id;

  int get skillLevel => _skillLevel;

  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'skillLevel': _skillLevel,
      'id': _id,
      'photoUrl': _photoUrl
    };
  }

  @override
  String toString() =>
      'User: $username, $skillLevel, $id, $photoUrl, $gender, $events';

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
      await removeFirebaseData("users/$id");
      await user?.delete();
      print("User deleted successfully");
    } catch (e) {
      print("Failed to delete user: ${e.toString()}");
    }
  }

  void pickProfilePicture() async {
    // Open gallery to select an image
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload image to Firebase Storage
      final path = 'user_profiles/${DateTime.now().millisecondsSinceEpoch}';
      await uploadFileToFirebaseStorage(File(pickedFile.path), path);
      // Update user profile picture URL
      photoUrl =
          await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    }
  }

  // static methods

  static bool isUserSignedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
