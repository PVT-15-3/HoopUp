import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

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
            String? gender = user.gender;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        gender = 'male';
                      },
                      child: const Text('male'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        gender = 'female';
                      },
                      child: const Text('female'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        gender = 'other';
                      },
                      child: const Text('other'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    user.pickProfilePicture();
                  },
                  child: const Text('Select profile picture'),
                ),
                ElevatedButton(
                  onPressed: () {
                    user.skillLevel = skillLevel;
                    user.gender = gender!;
                    if (controller.text.length >= 4) {
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
