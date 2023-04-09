import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/classes/hoopup_user.dart';
import '../services/sign_in.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // initialize Firebase app
  }

  HoopUpUser? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              child: Text('Go to Map'),
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text('auth test'),
              onPressed: () async {
                final user = await signInWithGoogle();
                setState(() {
                  currentUser = user;
                });
                print(currentUser);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text('remove user'),
              onPressed: () {
                currentUser?.deleteAccount();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text('log out user'),
              onPressed: () {
                HoopUpUser.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
