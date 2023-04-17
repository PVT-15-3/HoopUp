import 'package:flutter/material.dart';

class EventViewerPage extends StatefulWidget {
  EventViewerPage({Key? key}) : super(key: key);

  @override
  _EventViewerPageState createState() => _EventViewerPageState();
}

class _EventViewerPageState extends State<EventViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Events"),
      ),
    );
  }
}
