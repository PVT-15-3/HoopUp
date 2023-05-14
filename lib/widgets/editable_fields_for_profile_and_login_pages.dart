import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/int_controller.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';

import '../classes/hoopup_user.dart';
import '../providers/hoopup_user_provider.dart';
import 'bottom_nav_bar.dart';

class EditableFields extends StatefulWidget {
  EditableFields({Key? key}) : super(key: key);

  @override
  State<EditableFields> createState() => _EditableFieldsState();
}

class _EditableFieldsState extends State<EditableFields> {
  late HoopUpUser user;
  late String username;
  late int skillLevel;
  late String gender;
  late int age;
  late final String photoUrl;
  late bool loggedIn;
  late String email;
  late List<Widget> stars;

  final nameController = TextEditingController();
  final ageController = IntEditingController();
  final emailController = TextEditingController();

  void generateStars() {
    stars = List.generate(
      5,
      (index) => GestureDetector(
        child: Icon(
          size: 30,
          index < skillLevel ? Icons.star : Icons.star_border,
          color: index < skillLevel ? Colors.orange : Colors.grey,
        ),
        onTap: () {
          setState(() {
            skillLevel = index + 1;
            generateStars();
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<HoopUpUserProvider>();
    if (userProvider.user == null) {
      //TODO fix this for login
      loggedIn = false;
      photoUrl = "";
    } else {
      //For profile page, there exists a user.
      loggedIn = true;
      user = userProvider.user!;
      username = user.username;
      skillLevel = user.skillLevel;
      gender = user.gender;
      age = user.age;
      photoUrl = user.photoUrl;
      email = FirebaseAuth.instance.currentUser?.email as String;
      nameController.text = username;
      emailController.text = email;
      ageController.setIntValue(age);
    }

    generateStars();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Edit picture ---------------------------------------------------
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
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 50,
                ),
                const Text("Edit picture"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          //Edit skill level -----------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stars,
          ),
          const SizedBox(height: 30),

          Container(
              margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(children: [
                //Edit gender ----------------------------------------------
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gender = "Male";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              gender == "Male" ? Colors.orange : Colors.white,
                          minimumSize: const Size(90, 50),
                          elevation: 5,
                        ),
                        child: const Text("MALE")),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gender = "Female";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              gender == "Female" ? Colors.orange : Colors.white,
                          minimumSize: const Size(90, 50),
                          elevation: 5,
                        ),
                        child: const Text("FEMALE")),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gender = "Other";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              gender == "Other" ? Colors.orange : Colors.white,
                          minimumSize: const Size(90, 50),
                          elevation: 5,
                        ),
                        child: const Text("OTHER")),
                  ],
                ),
                const SizedBox(height: 20),

                //Edit User name ------------------------------------------
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: username,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12)),
                ),
                const SizedBox(height: 20),

                //Edit email -----------------------------------------------
                TextField(
                  controller: emailController,
                  enabled: !loggedIn,
                  decoration: InputDecoration(
                      fillColor: Colors.black12,
                      filled: loggedIn,
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2.0)),
                      labelText: 'Email',
                      hintText: email,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12)),
                ),
                const SizedBox(height: 20),

                //Edit age -------------------------------------------------
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Age",
                      hintText: "$age",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12)),
                ),
                const SizedBox(height: 20),
              ])),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavBar()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(100, 60),
                  elevation: 5,
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.length >= 3) {
                    if (ageController.getIntValue() >= 13) {
                      user.skillLevel = skillLevel;
                      user.gender = gender;
                      user.age = ageController.getIntValue();
                      user.username = nameController.text;
                      user.photoUrl = photoUrl;
                      showCustomToast("Profile updated", Icons.person, context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()),
                      );
                    }
                  } else {
                    showCustomToast(
                        "Username is too short", Icons.warning, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(100, 60),
                  elevation: 5,
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
