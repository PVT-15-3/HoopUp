import 'package:flutter/material.dart';
import '../handlers/list_event_handler.dart';

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
      body: ListEventHandler(
        showJoinedEvents: showJoinedEvents,
      ),
    );
  }
}
