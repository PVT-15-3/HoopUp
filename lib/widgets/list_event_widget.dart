import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/app_styles.dart';
import 'package:my_app/providers/firebase_provider.dart';
import '../classes/event.dart';
import 'package:rxdart/subjects.dart';
import 'event_list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;

import 'filter_events.dart';

class ListEventWidget extends StatefulWidget {
  final bool showJoinedEvents;
  const ListEventWidget({super.key, required this.showJoinedEvents});

  @override
  _ListEventWidgetState createState() => _ListEventWidgetState();
}

class _ListEventWidgetState extends State<ListEventWidget> {
  int amountOfExistingCards = 0;
  final BehaviorSubject<List<Event>> _eventsController =
      BehaviorSubject<List<Event>>.seeded([]);
  late StreamSubscription<List<Event>> _eventsSubscription;
  late final FirebaseProvider firebaseProvider;

  bool noEventsToShow = false;

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

  void handleCardExists() {
    amountOfExistingCards++;
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 750), () {
        if (amountOfExistingCards == 0 && mounted) {
          setState(() {
            noEventsToShow = true;
          });
        }
      });
    });
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
                          setState(() {
                            noEventsToShow = false;
                          });

                          return EventListItem(
                            key: UniqueKey(),
                            event: event,
                            showJoinedEvents: widget.showJoinedEvents,
                            onCardExists: handleCardExists,
                          );
                        },
                      ),
                      if (events == null || events.isEmpty)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (noEventsToShow && widget.showJoinedEvents)
                        Center(
                          child: Text(
                            'You have not booked any events yet \u{1F614}',
                            style: TextStyle(
                              fontSize: Styles.fontSizeSmall,
                            ),
                          ),
                        ),
                      if (noEventsToShow && !(widget.showJoinedEvents))
                        Center(
                          child: Text(
                            'There are no bookable events to join right now \u{1F614}',
                            style: TextStyle(
                              fontSize: Styles.fontSizeSmall,
                            ),
                          ),
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
