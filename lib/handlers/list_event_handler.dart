import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/providers/firebase_provider.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';
import '../widgets/event_list_item.dart';
import 'package:provider/provider.dart';

class ListEventHandler extends StatefulWidget {
  final bool showJoinedEvents;
  const ListEventHandler({super.key, required this.showJoinedEvents});

  @override
  _ListEventHandlerState createState() => _ListEventHandlerState();
}

class _ListEventHandlerState extends State<ListEventHandler> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);
  late StreamSubscription<List<Event>> _eventsSubscription;
  bool joined = false;

  @override
  void initState() {
    super.initState();
    final firebaseProvider = context.read<FirebaseProvider>();
    _eventsSubscription = firebaseProvider.eventsStream.listen((events) {
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
