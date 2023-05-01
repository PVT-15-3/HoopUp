import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<HoopUpUserProvider>();
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
              child: const Text('remove user'),
              onPressed: () {
                userProvider.user?.deleteAccount();
                userProvider.clearUser();
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('test user'),
              onPressed: () {
                print("!!!!!!!!");
                print(HoopUpUser.isUserSignedIn());
                print(userProvider.user);
                print("!!!!!!!!");
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('log out user'),
              onPressed: () {
                HoopUpUser.signOut();
                userProvider.clearUser();
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_event_wizard.dart');
              },
              child: const Text('create event wizard'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile_page.dart');
              },
              child: const Text('go to profile page'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list_events.dart');
              },
              child: const Text('List events'),
            ),
          )
        ],
      ),
    );
  }
}
