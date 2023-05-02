import 'package:uuid/uuid.dart';
import 'message.dart';
import 'package:my_app/providers/firebase_provider.dart';

class Chat {
  final String _eventId;
  final String _id;
  final List<Message> _messages = [];
  final FirebaseProvider _firebaseProvider;

  Chat({required String eventId, required FirebaseProvider firebaseProvider})
      : _eventId = eventId,
        _firebaseProvider = firebaseProvider,
        _id = const Uuid().v4();

  //Getters

  String get id => _id;

  List<Message> get messages => _messages;

  //Handle events
  void addMessage(Message message) {
    _messages.add(message);
    _firebaseProvider.setFirebaseDataMap(
        "events/$_eventId/chat/messages/${message.id}", message.toJson());
  }

  void removeMessage(Message message) {
    if (_messages.contains(message)) {
      _messages.remove(message);
      _firebaseProvider
          .removeFirebaseData("events/$_eventId/chat/messages/${message.id}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'eventId': _eventId,
      'messages': _messages.map((m) => m.toJson()).toList(),
    };
  }
}
