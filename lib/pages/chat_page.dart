import 'package:flutter/material.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/message.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';
import '../providers/firebase_provider.dart';

class ChatPage extends StatefulWidget {
  final Event event;

  ChatPage({required this.event});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  void _sendMessage(String username) {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      Message message = Message(
        username: username,
        messageText: messageText,
        timeStamp: DateTime.now(),
      );
      widget.event.chat.addMessage(message);
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);
    final String eventId = widget.event.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<Message>>(
            stream: firebaseProvider.getChatMessageStream(eventId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Message> messages = snapshot.data!;
                messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: messages.map((message) {
                      return ListTile(
                        title: Text(message.username),
                        subtitle: Text(message.messageText),
                      );
                    }).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(hoopUpUserProvider.user!.username),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
