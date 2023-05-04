import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              HoopUpUser.signOut();
              showCustomToast("You have logged out", Icons.logout, context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogInPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HoopUpUserProvider>(
          builder: (context, userProvider, child) {
            HoopUpUser user = userProvider.user!;
            int skillLevel = user.skillLevel;
            String gender = user.gender;

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
                    user.gender = gender;
                    if (controller.text.length >= 3) {
                      // TODO: how long should a username be?
                      user.username = controller.text;
                      showCustomToast("Profile updated", Icons.person, context);
                    } else {
                      showCustomToast(
                          "Username is too short", Icons.warning, context);
                    }
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: () {
                    userProvider.user?.deleteAccount();
                    showCustomToast(
                        "You have deleted your account", Icons.delete, context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogInPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: const Color(0xFFFAFAFA),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Delete account'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
