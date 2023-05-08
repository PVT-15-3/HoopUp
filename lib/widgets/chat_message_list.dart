import 'package:flutter/material.dart';
import '../classes/message.dart';

class ChatMessageList extends StatefulWidget {
  final List<Message> messages;

  ChatMessageList({required this.messages});

  @override
  _ChatMessageListState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        Message message = widget.messages[index];
        return ListTile(
          title: Text(message.username),
          subtitle: Text(message.messageText),
        );
      },
    );
  }
}
