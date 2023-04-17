import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/services/hoopup_user_provider.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class EventViewerPage extends StatelessWidget {
  EventViewerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('HoopUp'),
        Container(
          child: Column(
            children: [Text('My bookings')],
          ),
        ),
      ],
    ));
  }
}
