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
            int skillLevel = user!.skillLevel;

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
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        skillLevel = 1;
                      },
                      child: const Text('Beginner'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        skillLevel = 2;
                      },
                      child: const Text('Intermediate'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        skillLevel = 3;
                      },
                      child: const Text('Advanced'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    user.skillLevel = skillLevel;
                    if(controller.text.length >= 4) {
                      user.username = controller.text;
                    }
                  },
                  child: const Text('Save'),
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
