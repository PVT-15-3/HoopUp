import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!HoopUpUser.isUserSignedIn()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are not logged in'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogInPage(),
                  ),
                );
              },
              child: const Text('Press here to log in'),
            ),
          ],
        ),
      );
    }
    var userProvider = context.watch<HoopUpUserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              HoopUpUser.signOut();
              userProvider.clearUser();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HoopUpUserProvider>(
          builder: (context, userProvider, child) {
            HoopUpUser? user = userProvider.user;
            int skillLevel = user!.skillLevel;
            String? gender = user.gender;

            final controller = TextEditingController(text: user.username);
            if (userProvider.user == null) {
              return const Text('You are not logged in');
            }
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
                const SizedBox(height: 100.0),
                ElevatedButton(
                
                  onPressed: () {
                     HoopUpUser.signOut();
                    userProvider.user?.deleteAccount();
                    userProvider.clearUser();
                   
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
