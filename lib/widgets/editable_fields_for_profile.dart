import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/app_styles.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../classes/hoopup_user.dart';
import '../providers/firebase_provider.dart';
import '../providers/hoopup_user_provider.dart';
import 'bottom_nav_bar.dart';

class EditableFields extends StatefulWidget {
  const EditableFields({Key? key}) : super(key: key);

  @override
  State<EditableFields> createState() => _EditableFieldsState();
}

class _EditableFieldsState extends State<EditableFields> {
  late HoopUpUser user;
  late String username;
  late int skillLevel;
  late String gender;
  late DateTime dateOfBirth;
  late String photoUrl;
  late String email;
  late List<Widget> stars;
  late FirebaseProvider firebaseProvider;

  final nameController = TextEditingController();
  final birthDayController = TextEditingController();
  final emailController = TextEditingController();

  void generateStars() {
    stars = List.generate(
      5,
      (index) => GestureDetector(
        child: Icon(
          size: 30,
          index < skillLevel ? Icons.star : Icons.star_border,
          color: index < skillLevel ? Styles.primaryColor : Colors.grey,
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
    firebaseProvider = context.read<FirebaseProvider>();
    user = userProvider.user!;
    username = user.username;
    skillLevel = user.skillLevel;
    gender = user.gender;
    dateOfBirth = user.dateOfBirth;
    photoUrl = user.photoUrl;
    email = FirebaseAuth.instance.currentUser?.email as String;
    nameController.text = username;
    emailController.text = email;
    birthDayController.text = "${DateTime.now().year - dateOfBirth.year}";
    generateStars();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Edit picture ---------------------------------------------------
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final path =
                        'user_profiles/${DateTime.now().millisecondsSinceEpoch}';
                    await firebaseProvider.uploadFileToFirebaseStorage(
                        File(pickedFile.path), path);
                    final newPhotoUrl = await FirebaseStorage.instance
                        .ref()
                        .child(path)
                        .getDownloadURL();
                    setState(() {
                      photoUrl = newPhotoUrl;
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: photoUrl != ""
                          ? NetworkImage(photoUrl)
                          : const AssetImage('assets/logo.png')
                              as ImageProvider<Object>,
                      radius: 50,
                    ),
                    const Text(
                      "Edit picture",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),

              //Edit skill level -----------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: stars,
              ),
              SizedBox(height: constraints.maxHeight * 0.05),

              Container(
                  margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.15, 0,
                      constraints.maxWidth * 0.15, 0),
                  child: Column(children: [
                    //Edit gender ----------------------------------------------
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  gender = "Male";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.08),
                                elevation: 5,
                                textStyle: TextStyle(
                                  fontSize: constraints.maxWidth * 0.025,
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: gender == "Male"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                      width: gender == "Male" ? 2 : 1,
                                    )),
                              ),
                              child: const Text("MALE")),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.05),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  gender = "Female";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.08),
                                elevation: 5,
                                textStyle: TextStyle(
                                  fontSize: constraints.maxWidth * 0.025,
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: gender == "Female"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                      width: gender == "Female" ? 2 : 1,
                                    )),
                              ),
                              child: const Text("FEMALE")),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.05),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  gender = "Other";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.08),
                                elevation: 5,
                                textStyle: TextStyle(
                                  fontSize: constraints.maxWidth * 0.025,
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: gender == "Other"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                      width: gender == "Other" ? 2 : 1,
                                    )),
                              ),
                              child: const Text("OTHER")),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),

                    //Edit User name ------------------------------------------
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: username,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: constraints.maxWidth * 0.03)),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),

                    //Edit email -----------------------------------------------
                    TextFormField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: 'Email',
                          hintText: email,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: constraints.maxWidth * 0.03)),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),

                    //Edit age -------------------------------------------------
                    TextFormField(
                      controller: birthDayController,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          labelText: 'Age',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: constraints.maxWidth * 0.03)),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.04),
                  ])),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBar(
                                    currentIndex: 3,
                                  )),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(constraints.maxWidth * 0.25,
                          constraints.maxHeight * 0.1),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: constraints.maxWidth * 0.06,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.length >= 3) {
                        user.skillLevel = skillLevel;
                        user.gender = gender;
                        user.username = nameController.text;
                        user.photoUrl = photoUrl;
                        Toaster.showCustomToast(
                            "Profile updated", Icons.person, context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar(
                                      currentIndex: 3,
                                    )),
                            (route) => false);
                      } else {
                        Toaster.showCustomToast(
                            "Username is too short", Icons.warning, context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(constraints.maxWidth * 0.25,
                          constraints.maxHeight * 0.1),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: constraints.maxWidth * 0.06,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
