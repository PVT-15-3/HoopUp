import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../classes/event.dart';
import 'package:rxdart/subjects.dart';

class JoinEventPage extends StatefulWidget {
  const JoinEventPage({super.key});

  @override
  _JoinEventPageState createState() => _JoinEventPageState();
}

class _JoinEventPageState extends State<JoinEventPage> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);

  late DatabaseReference _eventsRef;

  @override
  void initState() {
    super.initState();
    _eventsRef = FirebaseDatabase.instance.ref().child('events');

    _eventsRef.onValue.listen((event) {
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

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              itemCount: events?.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[300],
                  child: ListTile(
                    title: Text(events![index].name),
                    subtitle: Text(events[index].description),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
