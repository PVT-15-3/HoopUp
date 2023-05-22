import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/start_page.dart';
import 'package:my_app/providers/create_event_wizard_provider.dart';
import 'package:my_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../providers/hoopup_user_provider.dart';
import '../widgets/editable_fields_for_profile.dart';

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
      return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      HoopUpUser.signOut();
                      FilterProvider().clearFilters();
                      CreateEventWizardProvider().reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StartPage()),
                      );
                    },
                    icon: const Icon(Icons.logout)),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Consumer<HoopUpUserProvider>(
                    builder: (context, userProvider, child) {
                  HoopUpUser user = userProvider.user!;
                  String name = user.username;
                  int skillLevel = user.skillLevel;
                  String gender = user.gender;
                  DateTime dateOfBirth = user.dateOfBirth;
                  String? email = FirebaseAuth.instance.currentUser!.email;
                  String photoUrl = user.photoUrl;

                  List<Widget> stars = List.generate(
                    skillLevel,
                    (index) => Icon(
                        size: constraints.maxWidth * 0.08,
                        Icons.star,
                        color: Styles.primaryColor),
                  );
                  while (stars.length < 5) {
                    stars.add(Icon(
                        size: constraints.maxWidth * 0.08,
                        Icons.star_border,
                        color: Colors.grey));
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          //Profile picture
                          CircleAvatar(
                            radius: constraints.maxWidth * 0.15,
                            backgroundImage: photoUrl != ""
                                ? NetworkImage(photoUrl)
                                : const AssetImage('assets/logo.png')
                                    as ImageProvider<Object>,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),

                          //Name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.04,
                              fontFamily: Styles.mainFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //SkillLevel
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: stars,
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.15,
                            0, constraints.maxWidth * 0.15, 0),
                        child: Column(
                          children: [
                            //Email
                            TextFormField(
                              style: TextStyle(
                                fontSize: constraints.maxHeight * 0.02,
                                fontFamily: Styles.mainFont,
                              ),
                              readOnly: true,
                              initialValue: email,
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Styles.primaryColor,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                            ),
                            SizedBox(height: constraints.maxWidth * 0.05),
                            //Age
                            TextFormField(
                              style: TextStyle(
                                fontSize: constraints.maxHeight * 0.02,
                                fontFamily: Styles.mainFont,
                              ),
                              readOnly: true,
                              initialValue:
                                  "${DateTime.now().year - dateOfBirth.year}",
                              decoration: const InputDecoration(
                                labelText: "Age",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                            ),
                            SizedBox(height: constraints.maxWidth * 0.05),
                            //Gender
                            TextFormField(
                              style: TextStyle(
                                fontSize: constraints.maxHeight * 0.02,
                                fontFamily: Styles.mainFont,
                              ),
                              readOnly: true,
                              initialValue: gender,
                              decoration: const InputDecoration(
                                labelText: "Gender",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                            ),
                            SizedBox(height: constraints.maxWidth * 0.05),
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
                          minimumSize: Size(constraints.maxWidth * 0.5,
                              constraints.maxHeight * 0.1),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'EDIT\nPROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Styles.mainFont,
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxWidth * 0.05,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ));
      });
      //Editable values --------------------------------------------------------------------------
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: const EditableFields(),
      );
    }
  }
}
