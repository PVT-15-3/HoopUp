import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/widgets/editable_fields_for_profile_and_login_pages.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    //Normal page --------------------------------------------------------------------------
    if (!isEditable) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
          ),
          body: Center(
            child: Consumer<HoopUpUserProvider>(
                builder: (context, userProvider, child) {
              HoopUpUser user = userProvider.user!;
              String name = user.username;
              int skillLevel = user.skillLevel;
              String gender = user.gender;
              int age = user.age;
              String? email = FirebaseAuth.instance.currentUser!.email;
              String? photoUrl = user.photoUrl;

              List<Widget> stars = List.generate(
                skillLevel,
                //TODO change orage to uniform color
                (index) => const Icon(Icons.star, color: Colors.orange),
              );
              while (stars.length < 5) {
                stars.add(const Icon(Icons.star_border, color: Colors.grey));
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Column(
                    children: [
                      //Profile picture
                      const CircleAvatar(
                        radius: 50,
                        //TODO fix photoUrl
                        backgroundImage: AssetImage(""),
                      ),
                      const SizedBox(height: 20),

                      //Name
                      Text(name),

                      //SkillLevel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: stars,
                      ),
                      const SizedBox(height: 40),
                    ],
                  )),

                  Container(
                    margin: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                    child: Column(
                      children: [
                        //Email
                        TextFormField(
                          readOnly: true,
                          initialValue: email,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                //TODO change color
                                color: Colors.orange,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Age
                        TextFormField(
                          readOnly: true,
                          initialValue: "$age",
                          decoration: const InputDecoration(
                            labelText: "Age",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Gender
                        TextFormField(
                          readOnly: true,
                          initialValue: gender,
                          decoration: const InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  //Temporary logout button
                  ElevatedButton(
                      onPressed: () {
                        HoopUpUser.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log out')),

                  //Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditable = true;
                      });
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              );
            }),
          ));
      //Editable values --------------------------------------------------------------------------
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: const EditableFields(),
      );
    }
  }
}
