import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/classes/event.dart';
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
          /*   child: Consumer<HoopUpUserProvider>(
          builder: (context, userProvider, child) {
            HoopUpUser? user = userProvider.user;
            List<String>? events = user!.events;

            return Container(
              child: Column(
                children: <Widget>[
                  Text("$name's Bookings"),
                  for (var event in events)
                    Column(
                      children: [
                        Text(
                          event.name,
                        ),
                        Text(
                          'Game start: ${event.time.startTime.hour}',
                        ),
                        Text(
                          '${event.time.startTime.day}',
                        )
                      ],
                    )
                ],
              ),
            );
          },
        ),
    */
          ),
    );
  }
}
