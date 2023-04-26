import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';

import '../handlers/firebase_handler.dart';

class JoinEventPage extends StatefulWidget {
  const JoinEventPage({super.key});

  @override
  _JoinEventPageState createState() => _JoinEventPageState();
}

class _JoinEventPageState extends State<JoinEventPage> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);

  late DatabaseReference _eventsRef;
  late StreamSubscription<DatabaseEvent> _eventsSubscription; // Add this line

  @override
  void initState() {
    super.initState();
    _eventsRef = FirebaseDatabase.instance.ref().child('events');

    _eventsSubscription = _eventsRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<Event> events = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;

        print(map.toString());

        map.forEach((key, value) {
          final event = Event.fromJson(value);
          events.add(event);
        });
      }

      _eventsController.sink.add(events);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventsController.close();
    _eventsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join event'),
      ),
      body: Center(
        child: StreamBuilder<List<Event>>(
          stream: _eventsController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            List<Event>? events = snapshot.data;

            return ListView.builder(
              itemCount: events?.length,
              itemBuilder: (context, index) {
                final event = events![index];
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(event.name),
                        subtitle: Text(event.description),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle join event button press
                        joinEvent(event.id);
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerRight,
                      ),
                      child: const Text('Join Event'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');

Future<void> joinEvent(String eventId) async {
  // Get the currently logged-in user's ID
 final String? userId = FirebaseAuth.instance.currentUser?.uid;

if (userId == null) {
  // User is not logged in
  return;
}

Map? userMap = await getMapFromFirebase("users", userId);

List<dynamic> eventsList = userMap['events'] ?? [];

if (eventsList.contains(eventId)) {
  print('Event already joined');
} else {
   // Add the new event ID to the user's list
  eventsList.add(eventId);
  // Update the user's list of events in the database
  await _usersRef.child(userId).child('events').set(eventsList);
  print('Event joined');
}
  
}
