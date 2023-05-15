import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/Starting_page.dart';
import 'package:my_app/widgets/editable_fields_for_profile.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
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
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    HoopUpUser.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage()),
                    );
                  },
                  icon: const Icon(Icons.logout)),
            ],
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
              String photoUrl = user.photoUrl as String;

              List<Widget> stars = List.generate(
                skillLevel,
                //TODO change orage to uniform color
                (index) =>
                    const Icon(size: 30, Icons.star, color: Colors.orange),
              );
              while (stars.length < 5) {
                stars.add(const Icon(
                    size: 30, Icons.star_border, color: Colors.grey));
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Column(
                    children: [
                      //Profile picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: photoUrl != ""
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/logo.png')
                                as ImageProvider<Object>,
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

                  //Edit Profile Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditable = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(180, 70),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'EDIT\nPROFILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Styles.mainFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
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
        body: EditableFields(),
      );
    }
  }
}
