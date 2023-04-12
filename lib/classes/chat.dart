import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'message.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Chat {
  final String _eventId;
  final String _id;
  final List<Message> _messages = [];

  Chat({
    required String eventId,
  }) : 
  _eventId = eventId,
  _id = const Uuid().v4();

  //Getters

  String get id => _id;

  List<Message> get messages => _messages;


  //Handle events

  void addMessage(Message message) {
    _messages.add(message);
    database
        .ref("events/$_eventId/chat/messages/${message.id}")
        .set(message.toJson());
  }

  void removeMessage(Message message) {
    if (_messages.contains(message)) {
      _messages.remove(message);
      database.ref("events/$_eventId/chat/messages/${message.id}").remove();
    }
  }

  // void editMessage(Message message, String newText) {
  //   if (_messages.contains(message)) {
  //     message.messageText = newText;
  //     database
  //         .ref("events/$_eventId/chat/messages/${message.id}")
  //         .set(message.toJson());
  //   }
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'eventId': _eventId,
      'messages': _messages.map((m) => m.toJson()).toList(),
    };
  }
}
