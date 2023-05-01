import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';
import '../handlers/firebase_handler.dart';
import '../providers/hoopup_user_provider.dart';

class EventListItem extends StatefulWidget {
  final Event event;
  final bool showJoinedEvents;

  const EventListItem({
    Key? key, // Added a Key? parameter for super constructor
    required this.event,
    required this.showJoinedEvents,
  }) : super(key: key);

  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  late Future<bool> _joinedFuture;

  @override
  void initState() {
    super.initState();
    _joinedFuture = _checkJoined();
  }

  // Added type annotations for variables and return type
  Future<bool> _checkJoined() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      final Map userMap = await getMapFromFirebase("users", user.uid);
      final List<dynamic> eventsList = userMap['events'] ?? [];
      return eventsList.contains(widget.event.id);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Return a FutureBuilder that will build the UI based on the status of the _joinedFuture variable
    return FutureBuilder<bool>(
      future: _joinedFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

        // Check the connection state of the snapshot, and return a different widget depending on the state
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the snapshot is still waiting for data, return an empty SizedBox widget
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          // If there is an error with the snapshot, return a Text widget with the error message
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data != widget.showJoinedEvents) {
          // If the snapshot data is not equal to the showJoinedEvents variable, return an empty SizedBox widget
          return const SizedBox.shrink();
        } else {
          // Otherwise, get the value of the joined variable from the snapshot data
          final bool joined = snapshot.data ?? false;
          print(snapshot.data);
          // Build a Row widget with the event information and a button to join/cancel the event
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    title: Text(widget.event.name),
                    subtitle: Text(_getSubtitleText()),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Call the handleEvent function to join or cancel the event, and update the state to rebuild the UI
                  final bool joined = await handleEvent(widget.event.id);
                  setState(() {
                    _joinedFuture = _checkJoined();
                  });
                },
                child: Text(
                  joined ? 'Cancel event' : 'Join event',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  String _getSubtitleText() {
    final event = widget.event;
    return 'Event info: ${event.description}\n'
        'Date and time: ${event.time.getFormattedStartTime()}'
        '\nThe event is for: ${event.genderGroup}\n'
        'Number of participants allowed: ${event.playerAmount}\n'
        'Skill level: ${event.skillLevel}';
  }

  Future<bool> handleEvent(String eventId) async {
    // Get the currently logged-in user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    Map? eventMap = await getMapFromFirebase("events", eventId);
    Map? userMap = await getMapFromFirebase("users", userId!);

    List<String>? userIdsList = List.from(eventMap['userIds'] ?? []);
    List<String> eventsList = List.from(userMap['events'] ?? []);

    int numberOfPlayersInEvent = userIdsList.length;
    int numberOfAllowed = eventMap['playerAmount'];

    if (numberOfPlayersInEvent >= numberOfAllowed) {
      print('Event is full');
      return false;
    }
    if (eventsList.contains(eventId)) {
      removeUser(eventId, eventsList, userId, userIdsList);
      return false;
    } else {
      addUser(eventId, eventsList, userId, userIdsList);
      return true;
    }
  }

  removeUser(String eventId, List<String> eventsList, String userId,
      List<String> userIdsList) {
    // Remove the event ID from the user's list
    eventsList.remove(eventId);
    // Update the user's list of events in the database
    HoopUpUser? user =
        Provider.of<HoopUpUserProvider>(context, listen: false).user;
    user!.events = eventsList;

    // Remove the user's ID from the event's list of users
    userIdsList.remove(userId);

    // Update the event's list of users in the database
    setFirebaseDataList('events/$eventId/userIds', userIdsList);
  }

  addUser(String eventId, List<String> eventsList, String userId,
      List<String> userIdsList) {
    // Add the new event ID to the user's list
    List<String> newEventsList = List.from(eventsList)..add(eventId);

    // Update the user's list of events in the database
    HoopUpUser? user =
        Provider.of<HoopUpUserProvider>(context, listen: false).user;
    user!.events = newEventsList;

    // Add the user's ID to the event's list of users
    List<String> newUserIdsList = List.from(userIdsList)..add(userId);
    // Update the event's list of users in the database
    setFirebaseDataList('events/$eventId/userIds', newUserIdsList);
  }
}
