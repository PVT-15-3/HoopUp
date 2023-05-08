import 'package:flutter/material.dart';
import '../handlers/list_event_handler.dart';

class JoinedEventsPage extends StatelessWidget {
  final bool showJoinedEvents;
  const JoinedEventsPage({Key? key, required this.showJoinedEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(
              child: Text(
                'MY BOOKINGS',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListEventHandler(
              showJoinedEvents: showJoinedEvents,
            ),
          ),
        ],
      ),
    );
  }
}
