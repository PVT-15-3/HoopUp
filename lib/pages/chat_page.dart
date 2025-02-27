import 'package:flutter/material.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/message.dart';
import 'package:my_app/widgets/chat_message.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../app_styles.dart';
import '../classes/court.dart';
import '../providers/hoopup_user_provider.dart';
import '../providers/firebase_provider.dart';

class ChatPage extends StatefulWidget {
  final Event event;
  final Court court;

  const ChatPage({Key? key, required this.event, required this.court})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  List<Message> _sortedMessages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String username, String userPhotoUrl, String userId) {
    String messageText = _messageController.text.trim();

    final String stockholmTimezone = 'Europe/Stockholm';

    if (messageText.isNotEmpty) {
      final currentTimezone =
          tz.TZDateTime.now(tz.getLocation(stockholmTimezone));

      Message message = Message(
        username: username,
        userPhotoUrl: userPhotoUrl,
        userId: userId,
        messageText: messageText,
        timeStamp: currentTimezone,
      );
      widget.event.chat.addMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);
    final String eventId = widget.event.id;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Stockholm'));
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shadowColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Game at',
              style: TextStyle(
                fontFamily: Styles.mainFont,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                fontSize: 21,
                height: 1.19,
                letterSpacing: 0.05,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              widget.court.name,
              style: const TextStyle(
                fontFamily: Styles.mainFont,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                fontSize: 21,
                height: 1.19,
                letterSpacing: 0.05,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: firebaseProvider.getChatMessageStream(eventId),
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Message> messages = snapshot.data!;
                    messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
                    _sortedMessages = messages;
                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _sortedMessages.length,
                      itemBuilder: (context, index) {
                        final Message message = _sortedMessages[index];
                        return ChatMessage(
                          username: message.username,
                          userId: message.userId,
                          userPhotoUrl: message.userPhotoUrl,
                          messageText: message.messageText,
                          timestamp: message.timeStamp,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter your message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(Icons.send_sharp),
                        iconSize: 32,
                        onPressed: () => _sendMessage(
                          hoopUpUserProvider.user!.username,
                          hoopUpUserProvider.user!.photoUrl,
                          hoopUpUserProvider.user!.id,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
