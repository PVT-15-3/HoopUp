import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'event.dart';
import 'message.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Chat {
  final Event event;
  final String _id;
  final List<Message> _messages = [];

  Chat({
    required this.event,
  }) : _id = const Uuid().v4();

  //Getters

  String get id => _id;

  List<Message> get messages => _messages;

  //Handle events

  void addMessage(Message message) {
    _messages.add(message);
    var eventId = event.id;
    database
        .ref("events/$eventId/chat/messages/${message.id}")
        .set(message.toJson());
  }

  void removeMessage(Message message) {
    if (_messages.contains(message)) {
      _messages.remove(message);
      var eventId = event.id;
      database.ref("events/$eventId/chat/messages/${message.id}").remove();
    }
  }

  void editMessage(Message message, String newText) {
    if (_messages.contains(message)) {
      message.messageText = newText;
      var eventId = event.id;
      database
          .ref("events/$eventId/chat/messages/${message.id}")
          .set(message.toJson());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'eventId': event.id,
      'messages': _messages.map((m) => m.toJson()).toList(),
    };
  }
}
