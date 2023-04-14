import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../services/hoopup_user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<HoopUpUserProvider>(
          builder: (context, userProvider, child) {
            HoopUpUser? user = userProvider.user;
            HoopUpUser tempUser = HoopUpUser(
              username: user!.username,
              skillLevel: user.skillLevel,
              id: user.id,
              photoUrl: user.photoUrl,
            );

            final controller = TextEditingController(text: user.username);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: user.username,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text != "") {
                      user.username = controller.text;
                    }
                  },
                  child: const Text('Change name'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        user.skillLevel = 1;
                      },
                      child: const Text('Beginner'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        user.skillLevel = 2;
                      },
                      child: const Text('Intermediate'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        user.skillLevel = 3;
                      },
                      child: const Text('Advanced'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    userProvider.setUser(tempUser);
                    controller.text = tempUser.username;
                    controller.clear();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
