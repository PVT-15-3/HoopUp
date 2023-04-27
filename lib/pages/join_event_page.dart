import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';
import '../classes/event_list_item.dart';

class JoinEventPage extends StatefulWidget {
  const JoinEventPage({super.key});

  @override
  _JoinEventPageState createState() => _JoinEventPageState();
}

class _JoinEventPageState extends State<JoinEventPage> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);

  late DatabaseReference _eventsRef;
  late StreamSubscription<DatabaseEvent> _eventsSubscription;
  bool joined = false;

  @override
  void initState() {
    super.initState();
    _eventsRef = FirebaseDatabase.instance.ref().child('events');

    _eventsSubscription = _eventsRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<Event> events = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> eventsFromDatabaseMap = snapshot.value as Map;
      
        print(eventsFromDatabaseMap.toString());

        eventsFromDatabaseMap.forEach((key, value) {
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
                return EventListItem(event: event);
              },
            );
          },
        ),
      ),
    );
  }
}
