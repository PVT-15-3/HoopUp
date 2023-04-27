import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';

import '../handlers/firebase_handler.dart';

class EventListItem extends StatefulWidget {
  final Event event;

  const EventListItem({super.key, required this.event});

  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  bool _joined = false;

   _EventListItemState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User is logged in, check if they have already joined the event
        Map? userMap = await getMapFromFirebase("users", user.uid);
        List<dynamic> eventsList = userMap['events'] ?? [];
        bool joined = eventsList.contains(widget.event.id);
        setState(() {
          _joined = joined;
        });
      } else {
        // User is not logged in, set joined to false
        setState(() {
          _joined = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(widget.event.name),
            subtitle: Text(widget.event.description),
          ),
        ),
        TextButton(
          onPressed: () async {
            bool joined = await handleEvent(widget.event.id);
            setState(() {
              _joined = joined;
            });
          },
          child: Text(
            _joined ? 'Cancel event' : 'Join event',
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        )
      ],
    );
  }

final DatabaseReference _usersRef =
    FirebaseDatabase.instance.ref().child('users');

  Future<bool> handleEvent(String eventId) async {
  // Get the currently logged-in user's ID
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    // User is not logged in
    print('User is not logged in');
  }

  Map? userMap = await getMapFromFirebase("users", userId!);

  List<dynamic> eventsList = userMap['events'] ?? [];

  if (eventsList.contains(eventId)) {
    // Remove the event ID from the user's list
    eventsList.remove(eventId);
    // Update the user's list of events in the database
    await _usersRef.child(userId).child('events').set(eventsList);
    print('Event cancelled');
    return false;
  } else {
    // Add the new event ID to the user's list
    eventsList.add(eventId);
    // Update the user's list of events in the database
    await _usersRef.child(userId).child('events').set(eventsList);
    print('Event joined');
    return true;
  }
}
}