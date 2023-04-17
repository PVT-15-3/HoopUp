import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/classes/event.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class EventViewerPage extends StatelessWidget {
  Event _event;
  EventViewerPage({Key? key, required Event event})
      : _event = event,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.network(''),
        Container(
          child: Column(
            children: [
              //Name
              Text('something'),
              //Description
              Text('something else'),
              //User stats
              Container(),
            ],
          ),
        ),
        Text('Comments'),
        Container(
          child: Column(
            children: [
              //List all comments
            ],
          ),
        )
      ],
    ));
  }
}
