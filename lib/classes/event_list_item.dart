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
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _eventsRef =
      FirebaseDatabase.instance.ref().child('events');

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
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              title: Text(widget.event.name),
              subtitle: Text(
                  'Event info: ${widget.event.description}\n'
                  'Date and time: ${widget.event.time.getFormattedStartTime()}'
                  '\nThe event is for: ${widget.event.genderGroup}\n'
                  'Number of participants allowed: ${widget.event.playerAmount}\n'
                  'Skill level: ${widget.event.skillLevel}'),
            ),
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

  Future<bool> handleEvent(String eventId) async {
    // Get the currently logged-in user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    Map? eventMap = await getMapFromFirebase("events", eventId);
    Map? userMap = await getMapFromFirebase("users", userId!);

    List<String> userIdsList = List.from(eventMap['userIds'] ?? []);
    List<String> eventsList = List.from(userMap['events'] ?? []);

    int numberOfPlayersInEvent = userIdsList.length;
    int numberOfAllowed= eventMap['playerAmount'];


    if (userId == null) {
      // User is not logged in
      print('User is not logged in');
      return false;
    }

    if (numberOfPlayersInEvent >= numberOfAllowed ) {
      print('Event is full');
      return false;
    } 
    if (eventsList.contains(eventId)) {
      removeUser(eventId, eventsList, userId, userIdsList);
      return false;
    }
    else {
      addUser(eventId, eventsList, userId, userIdsList);
      return true;
    }
  }

  removeUser(String eventId, List<String> eventsList, String userId, List<String> userIdsList) async {
      // Remove the event ID from the user's list
      eventsList.remove(eventId);
      // Update the user's list of events in the database
      await _usersRef.child(userId).child('events').set(eventsList);
      print('Event cancelled');

      // Remove the user's ID from the event's list of users
      userIdsList.remove(userId);

      // Update the event's list of users in the database
      await _eventsRef.child(eventId).child('userIds').set(userIdsList);
    
  }

  addUser(String eventId, List<String> eventsList, String userId, List<String> userIdsList) async {
    // Add the new event ID to the user's list
      List<String> newEventsList = List.from(eventsList)..add(eventId);
      
      // Update the user's list of events in the database
      await _usersRef.child(userId).child('events').set(newEventsList);
      print('Event joined');

      // Add the user's ID to the event's list of users
      List<String> newUserIdsList = List.from(userIdsList)..add(userId);
      // Update the event's list of users in the database
      await _eventsRef.child(eventId).child('userIds').set(newUserIdsList);
  }
}
