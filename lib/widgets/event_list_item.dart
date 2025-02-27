import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app_styles.dart';
import 'package:my_app/classes/court.dart';
import 'package:my_app/handlers/filter_handler.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import '../classes/event.dart';
import '../pages/event_page.dart';
import '../providers/courts_provider.dart';
import '../providers/hoopup_user_provider.dart';
import '../handlers/event_handler.dart';
import 'toaster.dart';

class EventListItem extends StatefulWidget {
  final Event event;
  final bool showJoinedEvents;
  final Set<Court> _courts = CourtProvider().courts;
  late final Court _court;
  final VoidCallback onCardExists;

  EventListItem({
    Key? key, // Added a Key? parameter for super constructor
    required this.event,
    required this.showJoinedEvents,
    required this.onCardExists,
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
        } else if (!FilterHandler.filterEvent(
                widget._courts, _event, context) &&
            !widget.showJoinedEvents) {
          // If the event does not pass the filter and the user has not joined the event, return an empty SizedBox widget
          return const SizedBox.shrink();
        } else {
          // Otherwise, get the value of the joined variable from the snapshot data
          final bool hasUserJoined = snapshot.data ?? false;
          // Build a Row widget with the event information and a button to join/cancel the event
          return FutureBuilder<bool>(
            future: loadAsyncData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (hasUserJoined) {
                widget.onCardExists();
                return returnMyBookingsView(hasUserJoined);
              } else {
                widget.onCardExists();
                return returnDiscoverGameView(hasUserJoined);
              }
            },
          );
        }
      },
    );
  }

  Future<bool> loadAsyncData() async {
    _eventMap = await _firebaseProvider.getMapFromFirebase("events", _event.id);
    _userIdsList = List.from(_eventMap['userIds'] ?? []);
    _numberOfPlayersInEvent = _userIdsList!.length;
    for (Court court in widget._courts) {
      if (court.courtId == _event.courtId) {
        widget._court = court;
        break;
      }
    }
    return true;
  }

  TextSpan _getSubtitleText() {
    final timeText = TextSpan(
      text: 'Time: ',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: Styles.subHeaderFont,
        color: Styles.discoverGametextColor,
        fontSize: Styles.fontSizeSmall,
      ),
      children: [
        TextSpan(
          text: _event.time.getFormattedStartAndEndTime(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );

    final dateText = TextSpan(
      text: '\nDate: ',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: Styles.subHeaderFont,
        color: Styles.discoverGametextColor,
        fontSize: Styles.fontSizeSmall,
      ),
      children: [
        TextSpan(
          text: _event.time.getFormattedDate(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );

    return TextSpan(
      children: [timeText, dateText],
    );
  }

  Future<void> toggleEvent(bool hasUserJoined) async {
    if (!mounted) {
      return;
    }
    HoopUpUserProvider userProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    if (_numberOfPlayersInEvent >= _event.playerAmount && !hasUserJoined) {
      Toaster.showCustomToast("This event is full!", Icons.error, context);
      return;
    }

    if (userProvider.user!.events.contains(_event.id)) {
      removeUserFromEvent(_event.id, userProvider.user!.events, _userIdsList!,
          userProvider, _firebaseProvider);
      Toaster.showCustomToast(
          "You have canceled your game at ${widget._court.name}",
          Icons.schedule,
          context);
    } else {
      addUserToEvent(_event, userProvider.user!);
      Toaster.showCustomToast("You have joined a game at ${widget._court.name}",
          Icons.schedule, context);
    }
  }

  InkWell returnDiscoverGameView(hasUserJoined) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EventPage(event: _event, hasUserJoined: hasUserJoined),
          ),
        );
      },
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
        shadowColor: Colors.grey.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15.0),
                height: 170,
                width: 320,
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(1),
                      spreadRadius: -25,
                      blurRadius: 20,
                      offset: const Offset(0, 9),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    widget._court.imageLink,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(35.0, 0, 40.0, 0.0),
                  child: Text(
                    widget._court.name.toUpperCase(),
                    style: const TextStyle(
                      wordSpacing: 3.0,
                      fontSize: Styles.fontSizeMedium,
                      fontWeight: FontWeight.normal,
                      color: Styles.discoverGametextColor,
                      fontFamily: Styles.headerFont,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(33.0, 0, 30.0, 0.0),
              child: Row(
                children: [
                  _event.skillLevel != 0
                      ? Row(
                          children: List.generate(
                            _event.skillLevel,
                            (index) => const Icon(
                              Icons.star_purple500_sharp,
                              color: Styles.primaryColor,
                              size: 25,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(0, 10.0),
                                    blurRadius: 25.0,
                                    color: Styles.shadowColor),
                              ],
                            ),
                          ),
                        )
                      : const Text(
                          "All skill levels",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Styles.fontSizeSmall,
                            fontFamily: Styles.subHeaderFont,
                            color: Styles.primaryColor,
                          ),
                        ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Styles.primaryColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _event.time.getFormattedTimeAndDate(),
                        style: const TextStyle(
                          fontSize: Styles.fontSizeSmallest,
                          fontWeight: FontWeight.normal,
                          color: Styles.discoverGametextColor,
                          fontFamily: Styles.headerFont,
                          // shadows: <Shadow>[
                          //   Shadow(
                          //       offset: Offset(0, 3.0),
                          //       blurRadius: 5.0,
                          //       color: Styles.shadowColor),
                          // ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget yourEventText() {
    if (_event.creatorId == _firebaseUser.uid) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Created by you',
            style: const TextStyle(
              fontSize: Styles.fontSizeSmall,
              fontWeight: FontWeight.bold,
              color: Styles.primaryColor,
              fontFamily: Styles.headerFont,
            ),
          ),
        ]),
      );
    }
    return const SizedBox.shrink();
  }

  Card returnMyBookingsView(bool hasUserJoined) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
      shadowColor: Colors.grey.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          yourEventText(),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 5.0, 16.0, 0.0),
            child: ListTile(
              title: Text(
                widget._court.name.toUpperCase(),
                style: const TextStyle(
                  fontFamily: Styles.subHeaderFont,
                  fontWeight: FontWeight.bold,
                  fontSize: Styles.fontSizeMedium,
                  color: Styles.textColorMyBookings,
                ),
              ),
              subtitle: Text.rich(
                _getSubtitleText(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 33,
                margin: const EdgeInsets.only(top: 22.0, bottom: 22.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: TextButton(
                  onPressed: () {
                    // Navigate to the ChatPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(
                            event: _event, hasUserJoined: hasUserJoined),
                      ),
                    );
                  },
                  child: const Text(
                    'SHOW EVENT',
                    style: TextStyle(
                      fontFamily: Styles.subHeaderFont,
                      fontWeight: FontWeight.w600,
                      fontSize: Styles.fontSizeSmallest,
                      color: Styles.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 42.0, height: 30.0),
              Container(
                height: 33,
                margin: const EdgeInsets.only(top: 22.0, bottom: 22.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Call the handleEvent function to join or cancel the event, and update the state to rebuild the UI
                    await toggleEvent(hasUserJoined);
                    setState(() {
                      _hasUserJoined = _checkJoined();
                    });
                  },
                  child: const Text(
                    'CANCEL BOOKING',
                    style: TextStyle(
                      fontFamily: Styles.subHeaderFont,
                      fontWeight: FontWeight.w600,
                      fontSize: Styles.fontSizeSmallest,
                      color: Styles.primaryColor,
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
}
