import 'package:flutter/material.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';

import '../classes/hoopup_user.dart';
import '../providers/hoopup_user_provider.dart';

class EditableFields extends StatefulWidget {
  const EditableFields({Key? key}) : super(key: key);

  @override
  State<EditableFields> createState() => _EditableFields();
}

class _EditableFields extends State<EditableFields> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<HoopUpUserProvider>(
        builder: (context, userProvider, child) {
          HoopUpUser user = userProvider.user!;
          String username = user.username;
          int skillLevel = user.skillLevel;
          String gender = user.gender;
          int age = user.age;

          final nameController = TextEditingController(text: username);
          final genderController = TextEditingController(text: gender);
          final dobController = TextEditingController(text: "$age");

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Edit picture
              ElevatedButton(
                onPressed: () async {
                  user.pickProfilePicture();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 50,
                      //TODO Fix photo URL
                      backgroundImage: AssetImage(""),
                    ),
                    Text("Edit picture"),
                  ],
                ),
              ),
              //Edit skill level
              const SizedBox(height: 40),

              Container(
                  margin: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                  child: Column(children: [
                    //Edit First name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: username,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Edit email

                    //Edit age
                    TextField(
                      controller: dobController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Age",
                        hintText: "$age",
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Edit gender
                    TextField(
                      controller: genderController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Gender',
                        hintText: gender,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ])),

              ElevatedButton(
                onPressed: () {
                  user.skillLevel = skillLevel;
                  user.gender = gender;
                  if (nameController.text.length >= 3) {
                    user.username = nameController.text;
                    showCustomToast("Profile updated", Icons.person, context);
                  } else {
                    showCustomToast(
                        "Username is too short", Icons.warning, context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
