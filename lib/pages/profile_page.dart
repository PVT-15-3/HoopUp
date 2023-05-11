import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../providers/hoopup_user_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditable = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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

              // Generate a list of star icons based on the skill level
              List<Widget> stars = List.generate(
                skillLevel,
                //TODO change orage to uniform color
                (index) => const Icon(Icons.star, color: Colors.orange),
              );
              // Add empty star icons to fill up the rest of the row
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
                        backgroundImage: AssetImage('assets/profile_pic.jpg'),
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
                          //TODO Email
                          initialValue: name,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Age
                        TextFormField(
                          readOnly: true,
                          //TODO Age
                          initialValue: "18",
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
                        nameController.text = 'John Doe';
                        emailController.text = 'john.doe@example.com';
                        dobController.text = '1990';
                        genderController.text = 'Male';
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
        body: Center(
          child: Consumer<HoopUpUserProvider>(
            builder: (context, userProvider, child) {
              HoopUpUser user = userProvider.user!;
              String username = user.username;
              int skillLevel = user.skillLevel;
              String gender = user.gender;

              final controller = TextEditingController(text: username);
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
                          backgroundImage: AssetImage('assets/profile_pic.jpg'),
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
                          controller: controller,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Username',
                            hintText: username,
                          ),
                        ),
                        const SizedBox(height: 20),

                        //Edit email
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'E-mail',
                            hintText: "this is my email address smile",
                          ),
                        ),
                        const SizedBox(height: 20),

                        //Edit age
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Age',
                            hintText: "18",
                          ),
                        ),
                        const SizedBox(height: 20),

                        //Edit gender
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'E-mail',
                            hintText: gender,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ])),

                  ElevatedButton(
                    onPressed: () {
                      user.skillLevel = skillLevel;
                      user.gender = gender;
                      if (controller.text.length >= 3) {
                        user.username = controller.text;
                        showCustomToast(
                            "Profile updated", Icons.person, context);
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
        ),
      );
    }
  }
}
