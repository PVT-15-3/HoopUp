import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'hoopup_user.dart';

class Message {
  final String _id;
  final HoopUpUser _user;
  String _messageText;
  String _timeStamp;

  Message({
    required HoopUpUser user,
    required String messageText,
  })  : _id = const Uuid().v4(),
        _user = user,
        _messageText = messageText,
        _timeStamp = DateFormat('MM-dd HH:mm:ss').format(DateTime.now());

  String get id => _id;

  HoopUpUser get user => _user;

  String get messageText => _messageText;

  String get timeStamp => _timeStamp;

  set messageText(String text) => _messageText = text;

  set timeStamp(String timestamp) => _timeStamp = timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'user': {'username': _user.username},
      'messageText': _messageText,
      'timeStamp': _timeStamp,
    };
  }
}
