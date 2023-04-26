import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/handlers/firebase_handler.dart';
import 'package:provider/provider.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class ListEventsPage extends StatelessWidget {
  ListEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View events'),
      ),
      body: Center(
        child: Consumer<HoopUpUserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<Map<dynamic, dynamic>>(
              future: getMapFromFirebase(
                "",
                "events",
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  final map = snapshot.data!;
                  return Text(map.toString());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
