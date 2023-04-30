import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../handlers/event_handler.dart';
import '../providers/hoopup_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../handlers/firebase_handler.dart';
import 'create_event.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

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
                      builder: (context) => const CreateEventPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
                child: const Text('Create Event')),
          ),
          const SizedBox(height: 40),
          const Expanded(
            child: Center(
              child: EventHandler(showJoinedEvents: false),
            ),
          ),
        ],
      ),
    );
  }
}
