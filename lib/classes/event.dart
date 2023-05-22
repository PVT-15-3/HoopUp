import 'package:flutter/cupertino.dart';
import 'package:my_app/classes/message.dart';
import 'chat.dart';
import 'time.dart';
import 'package:my_app/providers/firebase_provider.dart';

class Event {
  final String _name;
  final String _description;
  final String _creatorId;
  late Chat _chat;
  final Time _time;
  final String _courtId;
  final String _id;
  final FirebaseProvider _firebaseProvider;
  int _skillLevel;
  int _playerAmount;
  String _genderGroup;
  int _minimumAge;
  int _maximumAge;
  List<String> _usersIds = [];

  Event({
    required String name,
    required String description,
    required String creatorId,
    required Time time,
    required String courtId,
    required int skillLevel,
    required int playerAmount,
    required int minimumAge,
    required int maximumAge,
    required String genderGroup,
    required String id,
    required FirebaseProvider firebaseProvider,
  })  : _name = name,
        _firebaseProvider = firebaseProvider,
        _description = description,
        _creatorId = creatorId,
        _time = time,
        _courtId = courtId,
        _skillLevel = skillLevel,
        _playerAmount = playerAmount,
        _minimumAge = minimumAge,
        _maximumAge = maximumAge,
        _genderGroup = genderGroup,
        _id = id {
    _chat = Chat(eventId: _id, firebaseProvider: firebaseProvider);
    {
      _validateSkillLevel(skillLevel);
      _validatePlayerAmount(playerAmount);
    }
  }

  addEventToDatabase() {
    try {
      _usersIds.add(_creatorId);
      _time.validateStartTime();
      _time.validateEndTime();
      _firebaseProvider.setFirebaseDataMap("events/$_id", {
        'name': _name,
        'description': _description,
        'creatorId': _creatorId,
        'time': _time.toJson(),
        'courtId': _courtId,
        'chat': _chat.toJson(),
        'skillLevel': _skillLevel,
        'playerAmount': _playerAmount,
        'genderGroup': _genderGroup,
        'minimumAge': _minimumAge,
        'maximumAge': _maximumAge,
        'userIds': _usersIds,
      });
    } on Exception catch (e) {
      debugPrint("Failed to add event to database: $e");
    }
  }

  // Getters --------------------------------------------------------------

  String get name => _name;
  String get description => _description;
  String get creatorId => _creatorId;
  String get id => _id;
  Time get time => _time;
  String get courtId => _courtId;
  int get skillLevel => _skillLevel;
  int get playerAmount => _playerAmount;
  int get minimumAge => _minimumAge;
  int get maximumAge => _maximumAge;
  String get genderGroup => _genderGroup;
  Chat get chat => _chat;
  List<String> get userIds => _usersIds;

  // Setters --------------------------------------------------------------
  set userIds(List<String> userIds) {
    _usersIds = userIds;
    _firebaseProvider.setFirebaseDataList('events/$id/userIds', userIds);
  }

  // Validate inputs -----------------------------------------------------

  void _validateSkillLevel(int skillLevel) {
    if (skillLevel < 0 || skillLevel > 5) {
      throw ArgumentError('Skill level should be between 0 and 5');
    }
  }

  void _validatePlayerAmount(int playerAmount) {
    if (playerAmount < 2 || playerAmount > 20) {
      throw ArgumentError('Player amount should be between 2 and 20');
    }
  }

  @override
  toString() {
    return 'Event: $name, $description, $creatorId, $time, $courtId, $skillLevel, $playerAmount, $genderGroup, $minimumAge, $maximumAge, $id';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'creatorId': _creatorId,
      'time': _time.toJson(),
      'courtId': _courtId,
      'chat': _chat.toJson(),
      'skillLevel': _skillLevel,
      'playerAmount': _playerAmount,
      'genderGroup': _genderGroup,
      'minimumAge': _minimumAge,
      'maximumAge': _maximumAge,
    };
  }

  factory Event.fromJson(
      Map<dynamic, dynamic> json, FirebaseProvider firebaseHandler) {
    final name = json['name'] as String;
    final description = json['description'] as String;
    final creatorId = json['creatorId'] as String;
    final time = Time.fromJson(json['time']);
    final courtId = json['courtId'] as String;
    final skillLevel = json['skillLevel'] as int;
    final playerAmount = json['playerAmount'] as int;
    final genderGroup = json['genderGroup'] as String;
    final minimumAge = json['minimumAge'] as int;
    final maximumAge = json['maximumAge'] as int;

    // This is only to get the event id. The chat is not used. Maybe we should change this.
    Map<dynamic, dynamic> chatJason = json['chat'] as Map<dynamic, dynamic>;
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
      minimumAge: minimumAge,
      maximumAge: maximumAge,
      id: id,
      firebaseProvider: firebaseHandler,
    );
    // Get messages from json and add them to the event
    dynamic messageMap = json['chat']['messages'];
    if (messageMap != null) {
      List<Message> messages = [];
      messageMap.forEach((key, value) {
        messages.add(Message.fromFirebase(Map<String, dynamic>.from(value)));
      });
      event._chat.messages = messages;
    }
    // Get list of users that have joined from json and add them to the event
    event._usersIds = List<String>.from(json['userIds'] ?? []);
    return event;
  }
}
