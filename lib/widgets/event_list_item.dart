import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';
import '../providers/hoopup_user_provider.dart';
import '../handlers/event_handler.dart';
import 'toaster.dart';

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
  late Future<bool> _hasUserJoined;
  late final FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _hasUserJoined = _checkJoined();
  }

  // Added type annotations for variables and return type
  Future<bool> _checkJoined() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      final Map userMap =
          await _firebaseProvider.getMapFromFirebase("users", user.uid);
      final List<dynamic> eventsList = userMap['events'] ?? [];
      return eventsList.contains(widget.event.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseProvider = context.read<FirebaseProvider>();
    // Return a FutureBuilder that will build the UI based on the status of the _joinedFuture variable
    return FutureBuilder<bool>(
      future: _hasUserJoined,
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
          final bool hasUserJoined = snapshot.data ?? false;
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
                  await toggleEvent(widget.event.id, hasUserJoined);
                  setState(() {
                    _hasUserJoined = _checkJoined();
                  });
                },
                child: Text(
                  hasUserJoined ? 'Cancel event' : 'Join event',
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

  Future<void> toggleEvent(String eventId, bool hasUserJoined) async {
    // Get the currently logged-in user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    Map? eventMap =
        await _firebaseProvider.getMapFromFirebase("events", eventId);
    Map? userMap = await _firebaseProvider.getMapFromFirebase("users", userId!);

    List<String>? userIdsList = List.from(eventMap['userIds'] ?? []);
    List<String> eventsList = List.from(userMap['events'] ?? []);

    int numberOfPlayersInEvent = userIdsList.length;
    int numberOfAllowed = eventMap['playerAmount'];
    if (!mounted) {
      return;
    }
    HoopUpUserProvider userProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    if (eventIsFull(numberOfPlayersInEvent, numberOfAllowed, hasUserJoined)) {
      return;
    }

    if (eventsList.contains(eventId)) {
      removeUserFromEvent(eventId, eventsList, userId, userIdsList,
          userProvider, _firebaseProvider);
      return;
    } else {
      addUserToEvent(eventId, eventsList, userId, userIdsList, userProvider,
          _firebaseProvider);
      return;
    }
  }

  bool eventIsFull(
      int numberOfPlayersInEvent, int numberOfAllowed, bool hasUserJoined) {
    if (numberOfPlayersInEvent >= numberOfAllowed && !hasUserJoined) {
      showCustomToast("This event is full!", Icons.error, context);
      return true;
    }
    return false;
  }
}
