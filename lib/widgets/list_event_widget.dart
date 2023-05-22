import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/app_styles.dart';
import 'package:my_app/providers/firebase_provider.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';
import 'event_list_item.dart';
import 'package:provider/provider.dart';

import 'filter_events.dart';

class ListEventWidget extends StatefulWidget {
  final bool showJoinedEvents;
  const ListEventWidget({super.key, required this.showJoinedEvents});

  @override
  _ListEventWidgetState createState() => _ListEventWidgetState();
}

class _ListEventWidgetState extends State<ListEventWidget> {
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);
  late StreamSubscription<List<Event>> _eventsSubscription;
  late final FirebaseProvider firebaseProvider;

  bool joined = false;

  @override
  void initState() {
    super.initState();
    firebaseProvider = context.read<FirebaseProvider>();
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          widget.showJoinedEvents
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                      Text(
                        'DISCOVER GAME',
                        style: TextStyle(
                          fontSize: Styles.fontSizeBig,
                          fontWeight: FontWeight.w800,
                          color: Styles.discoverGameHeaderColor,
                          fontFamily: Styles.headerFont,
                        ),
                      ),
                      FilterIconButton(),
                    ]),
          Expanded(
            child: Center(
              child: StreamBuilder<List<Event>>(
                stream: _eventsController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  List<Event>? events = snapshot.data;
                  // Sort the events based on date
                  events?.sort((a, b) =>
                      a.time.startTime.millisecondsSinceEpoch -
                      b.time.startTime.millisecondsSinceEpoch);
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
