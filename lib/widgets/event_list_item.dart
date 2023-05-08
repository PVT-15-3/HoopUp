import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';
import '../pages/event_pages.dart';
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
  late Event _event;
  late Map _eventMap;
  late List<String>? _userIdsList;
  late int _numberOfPlayersInEvent;
  final User _firebaseUser = FirebaseAuth.instance.currentUser!;
  late final FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = context.read<FirebaseProvider>();
    _hasUserJoined = _checkJoined();
    _event = widget.event;
  }

  // Added type annotations for variables and return type
  Future<bool> _checkJoined() async {
    final Map userMap =
        await _firebaseProvider.getMapFromFirebase("users", _firebaseUser.uid);
    final List<dynamic> eventsList = userMap['events'] ?? [];
    return eventsList.contains(_event.id);
  }

  @override
  Widget build(BuildContext context) {
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
          return FutureBuilder<bool>(
            future: loadDataFromFirebase(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  shadowColor: Colors.grey.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 30.0, 16.0, 0.0),
                        child: ListTile(
                          title: Text(
                            _event.name.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                            _getSubtitleText(),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasUserJoined)
                            Container(
                              height: 33.0,
                              margin: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: Colors.orange, width: 2),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Navigate to the ChatPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventPage(event: _event),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'SHOW EVENT',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 30.0, height: 30.0),
                          Container(
                            height: 33.0,
                            margin:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                // Call the handleEvent function to join or cancel the event, and update the state to rebuild the UI
                                await _toggleEvent(hasUserJoined);
                                setState(() {
                                  _hasUserJoined = _checkJoined();
                                });
                              },
                              child: Text(
                                hasUserJoined ? 'CANCEL BOOKING' : 'JOIN EVENT',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Future<bool> loadDataFromFirebase() async {
    _eventMap = await _firebaseProvider.getMapFromFirebase("events", _event.id);
    _userIdsList = List.from(_eventMap['userIds'] ?? []);
    _numberOfPlayersInEvent = _userIdsList!.length;
    return true;
  }

  String _getSubtitleText() {
    return 'Time: ${_event.time.getFormattedStartAndEndTime()}'
        '\nDate: ${_event.time.getFormattedDate()}';
  }

  Future<void> _toggleEvent(bool hasUserJoined) async {
    Map? userMap =
        await _firebaseProvider.getMapFromFirebase("users", _firebaseUser.uid);
    List<String> eventsList = List.from(userMap['events'] ?? []);
    if (!mounted) {
      return;
    }
    HoopUpUserProvider userProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    if (_numberOfPlayersInEvent >= _event.playerAmount && !hasUserJoined) {
      showCustomToast("This event is full!", Icons.error, context);
      return;
    }

    if (eventsList.contains(_event.id)) {
      removeUserFromEvent(_event.id, eventsList, _userIdsList!, userProvider,
          _firebaseProvider);
      showCustomToast(
          "You have canceled ${_event.name}", Icons.schedule, context);
    } else {
      addUserToEvent(_event.id, eventsList, _userIdsList!, userProvider,
          _firebaseProvider);
      showCustomToast(
          "You have joined ${_event.name}", Icons.schedule, context);
    }
  }
}
