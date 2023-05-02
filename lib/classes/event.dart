import 'chat.dart';
import 'time.dart';
import 'package:my_app/providers/firebase_provider.dart';

class Event {
  final String _name;
  final String _description;
  final String? _creatorId;
  late Chat _chat;
  final Time _time;
  final String _courtId;
  final String _id;
  final FirebaseProvider _firebaseProvider;
  int _skillLevel;
  int _playerAmount;
  String _genderGroup;
  String _ageGroup;
  List<String> _usersIds = [];

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
    required FirebaseProvider firebaseProvider,
  })  : _name = name,
        _firebaseProvider = firebaseProvider,
        _description = description,
        _creatorId = creatorId,
        _time = time,
        _courtId = courtId,
        _skillLevel = skillLevel,
        _playerAmount = playerAmount,
        _genderGroup = genderGroup,
        _ageGroup = ageGroup,
        _id = id {
    _chat = Chat(eventId: _id, firebaseProvider: firebaseProvider);
    {
      _validateSkillLevel(skillLevel);
      _validatePlayerAmount(playerAmount);
    }
  }

  addEventToDatabase() {
    try {
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
        'ageGroup': _ageGroup,
      });
    } on Exception catch (e) {
      print("Failed to add event to database: $e");
    }
  }

  // Getters --------------------------------------------------------------

  String get name => _name;
  String get description => _description;
  String? get creatorId => _creatorId as String;
  String get id => _id;
  Time get time => _time;
  String get courtId => _courtId;
  int get skillLevel => _skillLevel;
  int get playerAmount => _playerAmount;
  String get ageGroup => _ageGroup;
  String get genderGroup => _genderGroup;
  Chat? get chat => _chat;
  List<String> get usersIds => _usersIds;

  // Setters --------------------------------------------------------------
  set userIds(List<String> userIds) {
    _usersIds = userIds;
    _firebaseProvider.setFirebaseDataList('events/$id/userIds', userIds);
  }

  // Validate inputs -----------------------------------------------------

  void _validateSkillLevel(int skillLevel) {
    if (skillLevel < 1 || skillLevel > 5) {
      throw ArgumentError('Skill level should be between 1 and 5');
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
      'chat': _chat.toJson(),
      'skillLevel': _skillLevel,
      'playerAmount': _playerAmount,
      'genderGroup': _genderGroup,
      'ageGroup': _ageGroup,
    };
  }

  factory Event.fromJson(
      Map<dynamic, dynamic> json, FirebaseProvider firebaseHandler) {
    final name = json['name'] as String;
    final description = json['description'] as String;
    final creatorId = json['creatorId'] ?? '';
    final time = Time.fromJson(json['time']);
    final courtId = json['courtId'] as String;
    final skillLevel = json['skillLevel'] as int;
    final playerAmount = json['playerAmount'] as int;
    final genderGroup = json['genderGroup'] as String;
    final ageGroup = json['ageGroup'] as String;

    // This is only to get the event id. The chat is not used. Maybe we should change this. If we need to
    // the chat in the fromJason method, we need to change the chat to a map in the Event class?
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
      ageGroup: ageGroup,
      id: id,
      firebaseProvider: firebaseHandler,
    );

    return event;
  }
}
