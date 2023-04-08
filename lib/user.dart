import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import './event.dart';
import './firebase_options.dart';
import 'package:flutter/material.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class User {
  String _username;
  int _skillLevel;
  final String _id;
  String _email;
  final List<Event> _events = [];

  User(
      {required String username,
      required int skillLevel,
      required String email})
      : _username = username,
        _id = const Uuid().v4(),
        _email = email,
        _skillLevel = skillLevel {
    _validateSkillLevel(skillLevel);
    _validateEmail(email);
    database.ref("users/$_id").set({
      "username": _username,
      "skillLevel": _skillLevel,
      "email": _email,
    });
  }

  // setters

  set username(String username) {
    _username = username;
    database.ref("users/$_id").update({"username": _username});
  }

  set skillLevel(int skillLevel) {
    _validateSkillLevel(skillLevel);
    _skillLevel = skillLevel;
    database.ref("users/$_id").update({"skillLevel": _skillLevel});
  }

  // getters

  String get username => _username;

  List<Event> get events => _events;

  int get skillLevel => _skillLevel;

  String get id => _id;

  String get email => _email;
  set email(String email) {
    _validateEmail(email);
    _email = email;
  }

  // handle events

  void addEvent(Event event) {
    var id = event.id;
    _events.add(event);
    database.ref("users/$_id/events/$id").set(event.toJson());
  }

  void removeEvent(Event event) {
    int index = _events.indexOf(event);
    if (index >= 0) {
      _events.removeAt(index);
      database.ref("users/$_id/events/${event.id}").remove();
    }
  }

  @override
  String toString() => 'User: $_username, $_skillLevel, $_id, $_email';

  // override equality operator

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          _username == other._username &&
          _skillLevel == other._skillLevel &&
          _email == other._email;

  @override
  int get hashCode =>
      _username.hashCode ^
      _skillLevel.hashCode ^
      _id.hashCode ^
      _email.hashCode;

  // validate inputs

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

  void deleteAccount() {
    database.ref("users/$_id").remove();
  }
}
