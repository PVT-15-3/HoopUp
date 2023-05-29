import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Message {
  final String _id;
  final String _username;
  final String _userPhotoUrl;
  final String _userId;
  final String _messageText;
  final DateTime _timeStamp;

  Message({
    required String username,
    required String userPhotoUrl,
    required String userId,
    required String messageText,
    required DateTime timeStamp,
  })  : _id = const Uuid().v4(),
        _username = username,
        _userPhotoUrl = userPhotoUrl,
        _userId = userId,
        _messageText = messageText,
        _timeStamp = timeStamp;

  String get id => _id;

  String get username => _username;

  String get userPhotoUrl => _userPhotoUrl;

  String get userId => _userId;

  String get messageText => _messageText;

  DateTime get timeStamp => _timeStamp;

  factory Message.fromFirebase(Map<String, dynamic> data) {
    return Message(
      username: data['username'] ?? '',
      userPhotoUrl: data['userPhotoUrl'] ?? '',
      userId: data['userId'] ?? '',
      messageText: data['messageText'] ?? '',
      timeStamp:
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(data['timeStamp'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'username': _username,
      'userPhotoUrl': _userPhotoUrl,
      'userId': _userId,
      'messageText': _messageText,
      'timeStamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(_timeStamp),
    };
  }
}
