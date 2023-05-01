import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../handlers/event_handler.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class JoinedEventsPage extends StatelessWidget {
  final bool showJoinedEvents;
  const JoinedEventsPage({Key? key, required this.showJoinedEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: EventHandler(showJoinedEvents: showJoinedEvents),
    );
  }
}
