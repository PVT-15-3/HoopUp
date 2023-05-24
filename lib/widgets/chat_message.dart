import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app_styles.dart';
import '../providers/hoopup_user_provider.dart';

class ChatMessage extends StatelessWidget {
  final String username;
  final String userPhotoUrl;
  final String userId;
  final String messageText;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.username,
    required this.userPhotoUrl,
    required this.userId,
    required this.messageText,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    bool isCurrentUser = userId == hoopUpUserProvider.user!.id;

    TextStyle usernameStyle = const TextStyle(
      fontFamily: Styles.mainFont,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.27,
      color: Color(0xFF000000),
    );

    TextStyle messageTextStyle = const TextStyle(
      fontFamily: Styles.mainFont,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      height: 1.15,
      letterSpacing: 1,
      color: Color(0xFF000000),
    );

    Color messageBackgroundColor =
        isCurrentUser ? const Color(0xFFFF984B) : const Color(0xFFFEE3CF);

    DateFormat timestampFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Expanded(
          child: ListTile(
            title: Row(
              children: [
                if (!isCurrentUser)
                  if (userPhotoUrl.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(userPhotoUrl),
                      ),
                    )
                  else
                    const Icon(Icons.person_pin),
                const SizedBox(width: 4),
                Expanded(
                  child: Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      username,
                      style: usernameStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                if (isCurrentUser)
                  if (userPhotoUrl.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(userPhotoUrl),
                      ),
                    )
                  else
                    const Icon(Icons.person_pin),
              ],
            ),
            subtitle: Tooltip(
              message: 'Posted at ${timestampFormat.format(timestamp)}',
              child: Wrap(
                children: [
                  Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: messageBackgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        messageText,
                        style: messageTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
