import 'package:flutter/material.dart';
import '../widgets/list_event_widget.dart';
import '/app_styles.dart';

class JoinedEventsPage extends StatelessWidget {
  final bool showJoinedEvents;
  const JoinedEventsPage({Key? key, required this.showJoinedEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 90.0),
            child: Center(
              child: Text(
                'MY BOOKINGS',
                style: TextStyle(
                    fontSize: Styles.fontSizeBig,
                    fontWeight: FontWeight.bold,
                    color: Styles.primaryColor,
                    fontFamily: Styles.headerFont),
              ),
            ),
          ),
          Expanded(
            child: ListEventWidget(
              showJoinedEvents: showJoinedEvents,
            ),
          ),
        ],
      ),
    );
  }
}
