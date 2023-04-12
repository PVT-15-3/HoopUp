import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../services/hoopup_user_provider.dart';
import '../services/sign_in.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

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
              child: const Text('Go to Map'),
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('login with google'),
              onPressed: () async {
                await signInWithGoogle(context);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('remove user'),
              onPressed: () {
                Provider.of<HoopUpUserProvider>(context, listen: false)
                    .user
                    ?.deleteAccount();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('test user'),
              onPressed: () {
                print("!!!!!!!!");
                print(HoopUpUser.isUserSignedIn());
                print(Provider.of<HoopUpUserProvider>(context, listen: false)
                    .user);
                print("!!!!!!!!");
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('log out user'),
              onPressed: () {
                HoopUpUser.signOut();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('login with email'),
              onPressed: () {
                Navigator.pushNamed(context, '/log_in_page.dart');
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('signup with email'),
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up_page.dart');
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_event.dart');
              },
              child: const Text('create event'),
            ),
          ),
        ],
      ),
    );
  }
}
