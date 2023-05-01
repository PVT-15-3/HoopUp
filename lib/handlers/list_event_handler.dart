import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';
import '../classes/event_list_item.dart';

class ListEventHandler extends StatefulWidget {
  final bool showJoinedEvents;
  const ListEventHandler({super.key, required this.showJoinedEvents});

  @override
  _ListEventHandlerState createState() => _ListEventHandlerState();
}

class _ListEventHandlerState extends State<ListEventHandler> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);
  late StreamSubscription<DatabaseEvent> _eventsSubscription;

  late DatabaseReference _eventsRef;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          widget.showJoinedEvents
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.orange,
                  height: 70,
                  alignment: Alignment.center,
                  child: const Text(
                    'Join Events',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          Expanded(
            child: Center(
              child: StreamBuilder<List<Event>>(
                stream: _eventsController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  List<Event>? events = snapshot.data;
                  return Stack(
                    children: [
                      ListView.builder(
                        itemCount: events?.length,
                        itemBuilder: (context, index) {
                          final event = events![index];
                          return EventListItem(
                              event: event,
                              showJoinedEvents: widget.showJoinedEvents);
                        },
                      ),
                      if (events == null || events.isEmpty)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
