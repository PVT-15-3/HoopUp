import 'package:uuid/uuid.dart';
import 'chat.dart';
import 'time.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Event {
  final String _name;
  final String _description;
  final String _creatorId;
  Chat? _chat;
  final Time _time;
  final String _courtId;
  final String _id;
  final List<String> _usersIds = [];

  Event( {required String name,
      required String description,
      required String creatorId,
      required Time time,
      required String courtId,
      }) 
      : _name = name, 
      _description = description, 
      _creatorId = creatorId,
      _time = time,
      _courtId = courtId,
      _id = const Uuid().v4()
      {
      _chat = Chat(eventId: _id);
       database.ref("events/$_id").set({
      'name': _name, 
      'description': _description,
      'creatorId': _creatorId,
      'time': _time.toJson(),
      'courtId': _courtId,
      'chat': _chat?.toJson()
    }).catchError((error) {
      print("Failed to create event: ${error.toString()}");
    });
      }
       
// getters for the class properties
  String get name => _name;
  String get description => _description;
  String get creatorId => _creatorId;
  String get id => _id;
  Time get time => _time;
  String get courtId => _courtId;
  Chat? get chat => _chat;
  List<String> get usersIds => _usersIds;

  Map<String, dynamic> toJson() {
    return {'name': _name, 'description': _description, 'creatorId': _creatorId, 'time': _time.toJson(), 'courtId': _courtId, 'chat': _chat?.toJson()};
  }
}
