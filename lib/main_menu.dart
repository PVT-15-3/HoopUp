import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './sign_in.dart';

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
              onPressed: () {
                signInWithGoogle();
              },
            ),
          ),
        ],
      ),
    );
  }
}
