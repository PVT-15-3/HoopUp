import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  final String _username;
  int _skillLevel;
  final int _id;
  String _email;

  User(
      {required String username,
      required int skillLevel,
      required int id,
      required String email})
      : _username = username,
        _id = id,
        _email = email,
        _skillLevel = skillLevel {
    _validateSkillLevel(skillLevel);
    _validateEmail(email);
  }

  String get username => _username;

  int get skillLevel => _skillLevel;
  set skillLevel(int skillLevel) {
    _validateSkillLevel(skillLevel);
    _skillLevel = skillLevel;
  }

  int get id => _id;

  String get email => _email;
  set email(String email) {
    _validateEmail(email);
    _email = email;
  }

  @override
  String toString() => 'User: $_username, $_skillLevel, $_id, $_email';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          _username == other._username &&
          _skillLevel == other._skillLevel &&
          _id == other._id &&
          _email == other._email;

  @override
  int get hashCode =>
      _username.hashCode ^
      _skillLevel.hashCode ^
      _id.hashCode ^
      _email.hashCode;

  void _validateSkillLevel(int skillLevel) {
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level must be between 0 and 5');
    }
  }

  void _validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$', caseSensitive: false);
    if (!emailRegex.hasMatch(email)) {
      throw ArgumentError('Invalid email address');
    }
  }
}

void main() {
  final user = User(
      username: 'John Doe', skillLevel: 3, id: 1, email: 'viktor@gmail.com');

  final user2 = User(
      username: 'John Doe', skillLevel: 3, id: 1, email: 'viktor@gmail.com');

  print(user == user2);
}
