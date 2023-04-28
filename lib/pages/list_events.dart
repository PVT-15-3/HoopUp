import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/pages/join_event_page.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class ListEventsPage extends StatelessWidget {
 final bool showJoinedEvents;
  const ListEventsPage({Key? key, required this.showJoinedEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JoinEventPage(showJoinedEvents: showJoinedEvents);
  }
}
