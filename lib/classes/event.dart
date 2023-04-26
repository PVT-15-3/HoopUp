import 'chat.dart';
import 'time.dart';
import 'package:firebase_database/firebase_database.dart';
import '../handlers/firebase_handler.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Event {
  final String _name;
  final String _description;
  final String? _creatorId;
  Chat? _chat;
  final Time _time;
  final String _courtId;
  final String _id;
  int _skillLevel;
  int _playerAmount;
  String _genderGroup;
  String _ageGroup;
  final List<String> _usersIds = [];

  Event({
    required String name,
    required String description,
    required String? creatorId,
    required Time time,
    required String courtId,
    required int skillLevel,
    required int playerAmount,
    required String genderGroup,
    required String ageGroup,
    required String id,
  })  : _name = name,
        _description = description,
        _creatorId = creatorId,
        _time = time,
        _courtId = courtId,
        _skillLevel = skillLevel,
        _playerAmount = playerAmount,
        _genderGroup = genderGroup,
        _ageGroup = ageGroup,
        _id = id {
    _chat = Chat(eventId: _id);
    {
      _validateSkillLevel(skillLevel);
      _validatePlayerAmount(playerAmount);
    }
  }

  addEventToDatabase() {
    database.ref("events/$_id").set({
      'name': _name,
      'description': _description,
      'creatorId': _creatorId,
      'time': _time.toJson(),
      'courtId': _courtId,
      'chat': _chat?.toJson(),
      'skillLevel': _skillLevel,
      'playerAmount': _playerAmount,
      'genderGroup': _genderGroup,
      'ageGroup': _ageGroup,
    }).catchError((error) {
      print("Failed to create event: ${error.toString()}");
    });
  }

// getters for the class properties
  String get name => _name;
  String get description => _description;
  String? get creatorId => _creatorId;
  String get id => _id;
  Time get time => _time;
  String get courtId => _courtId;
  int get skillLevel => _skillLevel;
  int get playerAmount => _playerAmount;
  String get ageGroup => _ageGroup;
  String get genderGroup => _genderGroup;
  Chat? get chat => _chat;
  List<String> get usersIds => _usersIds;

  //Handle events

  void addUser(String userId) {
    if (userId == _creatorId) {
      throw ArgumentError('Cannot add creator as a user.');
    }
    if (_usersIds.contains(userId)) {
      throw ArgumentError('User is already added to this event.');
    }
    _usersIds.add(userId);
    //database.ref("events/$_id/userIds/$userId");
    setFirebaseDataMap("events/$_id/userIds", {userId: userId});
  }

  void removeUser(String userId) {
    if (userId != _creatorId) {
      _usersIds.remove(userId);
      database.ref("events/$_id/userIds/$userId").remove();
    }
  }

  // Validate inputs
  void _validateSkillLevel(int skillLevel) {
    if (skillLevel < 1 || skillLevel > 3) {
      throw ArgumentError('Skill level should be between 1 and 3');
    }
  }

  void _validatePlayerAmount(int playerAmount) {
    if (playerAmount < 2 || playerAmount > 20) {
      throw ArgumentError('Player amount should be between 2 and 20');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'creatorId': _creatorId,
      'time': _time.toJson(),
      'courtId': _courtId,
      'chat': _chat?.toJson(),
      'skillLevel': _skillLevel,
      'playerAmount': _playerAmount,
      'genderGroup': _genderGroup,
      'ageGroup': _ageGroup,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
  final name = json['name'] as String;
  final description = json['description'] as String;
  final creatorId = json['creatorId'] ?? '';
  final time = Time.fromJson(json['time']);
  final courtId = json['courtId'] as String;
  final skillLevel = json['skillLevel'] as int;
  final playerAmount = json['playerAmount'] as int;
  final genderGroup = json['genderGroup'] as String;
  final ageGroup = json['ageGroup'] as String;
  Map<String, dynamic> chatJason = json['chat'] as Map<String, dynamic>;
  final id = chatJason['eventId'] as String;


  final event = Event(
    name: name,
    description: description,
    creatorId: creatorId,
    time: time,
    courtId: courtId,
    skillLevel: skillLevel,
    playerAmount: playerAmount,
    genderGroup: genderGroup,
    ageGroup: ageGroup,
    id: id,
  );

  return event;
}
}
