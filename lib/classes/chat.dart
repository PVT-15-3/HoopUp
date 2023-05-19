import 'package:uuid/uuid.dart';
import 'message.dart';
import 'package:my_app/providers/firebase_provider.dart';

class Chat {
  final String _eventId;
  final String _id;
  final List<Message> _messages = [];
  final FirebaseProvider _firebaseProvider;

  Stream<List<Message>> get messageStream =>
      _firebaseProvider.getChatMessageStream(_eventId);

  Chat({required String eventId, required FirebaseProvider firebaseProvider})
      : _eventId = eventId,
        _firebaseProvider = firebaseProvider,
        _id = const Uuid().v4();

  //Getters --------------------------------------------------------------

  String get id => _id;

  List<Message> get messages => _messages;

  set messages(List<Message> messages) {
    _messages.addAll(messages);
  }

  factory Chat.fromFirebase(String eventId, Map<String, dynamic> data) {
    List<Message> messages = [];
    if (data['messages'] != null) {
      messages = List.from(data['messages']).map((messageData) {
        return Message.fromFirebase(messageData);
      }).toList();
    }

    return Chat(
      eventId: eventId,
      firebaseProvider: FirebaseProvider(),
    ).._messages.addAll(messages);
  }

  //Handle events --------------------------------------------------------
  Future<void> addMessage(Message message) async {
    _messages.add(message);
    await _firebaseProvider.setFirebaseDataMap(
        "events/$_eventId/chat/messages/${message.id}", message.toJson());
  }

  void removeMessage(Message message) {
    if (_messages.remove(message)) {
      _firebaseProvider.removeFirebaseData(
        "events/$_eventId/chat/messages/${message.id}",
      );
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
