import 'package:flutter/material.dart';
import 'package:my_app/providers/firebase_provider.dart';
import '../handlers/list_event_handler.dart';

class JoinedEventsPage extends StatelessWidget {
  final bool showJoinedEvents;
  late final FirebaseProvider firebaseProvider;
  JoinedEventsPage({Key? key, required this.showJoinedEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    firebaseProvider = context.read<FirebaseProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Joined Events',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListEventHandler(
        showJoinedEvents: showJoinedEvents,
        firebase: firebaseProvider,
      ),
    );
  }
}
