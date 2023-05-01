import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/handlers/list_event_handler.dart';
import 'package:my_app/pages/create_event_wizard.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../handlers/firebase_handler.dart';
import 'create_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static HoopUpUser? user;

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<HoopUpUserProvider>();
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && userProvider.user == null && user == null) {
      print(firebaseUser);
      getUserFromFirebase(firebaseUser.uid).then((hoopUpUser) {
        userProvider.setUser(hoopUpUser);
        user = hoopUpUser;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('HoopUp'),
        actions: [
          IconButton(
            onPressed: () {
              print("!!!!!!!!");
              print(HoopUpUser.isUserSignedIn());
              print(userProvider.user);
              print("!!!!!!!!");
            },
            icon: const Icon(Icons.manage_accounts),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEventWizard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
              ),
              child: const Text(
                'Create Event',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Expanded(
            child: Center(
              child: ListEventHandler(showJoinedEvents: false),
            ),
          ),
        ],
      ),
    );
  }
}
