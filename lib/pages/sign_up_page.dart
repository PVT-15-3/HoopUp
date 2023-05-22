import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../handlers/login_handler.dart';
import '../providers/firebase_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/toaster.dart';

class SignUpPage extends StatefulHookWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final FirebaseProvider firebaseProvider;
  late final Auth auth;
  late int skillLevel;
  late String gender;
  late List<Widget> stars;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    firebaseProvider = context.read<FirebaseProvider>();
    auth = Auth(firebaseProvider);
    skillLevel = 0;
    gender = "";
  }

  void generateStars(final constraints) {
    double size = constraints.maxWidth * 0.1;
    stars = List.generate(
      5,
      (index) => GestureDetector(
        child: Icon(
          size: size,
          index < skillLevel ? Icons.star : Icons.star_border,
          color: index < skillLevel ? Styles.primaryColor : Colors.grey,
        ),
        onTap: () {
          setState(() {
            skillLevel = index + 1;
            generateStars(constraints);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmailValid = useState(true);
    final email = useState<String?>(null);
    final password = useState<String?>(null);
    final username = useState<String?>(null);
    final dateOfBirth = useState<DateTime>(DateTime(0));

    return LayoutBuilder(builder: (context, constraints) {
      generateStars(constraints);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //HoopUp Icon
                Image(
                  image: const AssetImage('assets/logo.png'),
                  width: constraints.maxWidth * 0.3,
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                const Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: Styles.mainFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
                //Edit skill level -----------------------------------------------
                const Text(
                  "Choose Skill Level",
                  style: TextStyle(
                    fontFamily: Styles.mainFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: stars,
                ),
                SizedBox(height: constraints.maxHeight * 0.03),

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
                                textStyle: TextStyle(
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxWidth * 0.025,
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.06),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: gender == "Male"
                                        ? Styles.primaryColor
                                        : Styles.textColor,
                                    width: gender == "Male" ? 2 : 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.male,
                                      color: gender == "Male"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("MALE"),
                                  ],
                                ),
                              ),
                            ),
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
                                textStyle: TextStyle(
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxWidth * 0.025,
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.06),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: gender == "Female"
                                        ? Styles.primaryColor
                                        : Styles.textColor,
                                    width: gender == "Female" ? 2 : 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.female,
                                      color: gender == "Female"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("FEMALE"),
                                  ],
                                ),
                              ),
                            ),
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
                                textStyle: TextStyle(
                                  fontFamily: Styles.mainFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxWidth * 0.025,
                                ),
                                backgroundColor: Colors.white,
                                minimumSize: Size(constraints.maxWidth * 0.1,
                                    constraints.maxHeight * 0.06),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: gender == "Other"
                                        ? Styles.primaryColor
                                        : Styles.textColor,
                                    width: gender == "Other" ? 2 : 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.transgender,
                                      color: gender == "Other"
                                          ? Styles.primaryColor
                                          : Styles.textColor,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("OTHER"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      //Edit User name ------------------------------------------
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(
                          fontFamily: Styles.mainFont,
                        ),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Username*',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: constraints.maxWidth * 0.03)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username.value = value;
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      //Edit age -------------------------------------------------
                      TextFormField(
                        readOnly: true,
                        controller: birthdayController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Date of birth*',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: constraints.maxWidth * 0.03)),
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.input,
                            initialDate: _selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((pickedDate) {
                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                                dateOfBirth.value = pickedDate;
                              });

                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate);
                              setState(() =>
                                  birthdayController.text = formattedDate);
                            } else {
                              showCustomToast("Pick a date",
                                  Icons.warning_amber_outlined, context);
                            }
                          });
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      //Edit email -----------------------------------------------
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontFamily: Styles.mainFont,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2.0)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: constraints.maxWidth * 0.03),
                          labelText: 'Email*',
                          errorText: isEmailValid.value
                              ? null
                              : 'Please enter a valid email',
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final isValid =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value);
                          isEmailValid.value = isValid;
                          return isValid ? null : 'Please enter a valid email';
                        },
                        onSaved: (value) {
                          email.value = value;
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      //Edit password ------------------------------------------------
                      TextFormField(
                        obscureText: true,
                        style: const TextStyle(
                          fontFamily: Styles.mainFont,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: constraints.maxWidth * 0.03),
                          labelText: 'Password*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password.value = value;
                        },
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      //SaveButton ---------------------------------------------------
                      ElevatedButton(
                        onPressed: () async {
                          DateTime thresholdDate = DateTime.now()
                              .subtract(const Duration(days: 13 * 365));

                          if (dateOfBirth.value.isAfter(thresholdDate)) {
                            showCustomToast(
                                "You must be at least 13 years old to use HoopUp",
                                Icons.warning,
                                context);
                            return;
                          }
                          if (dateOfBirth.value == DateTime(0)) {
                            showCustomToast(
                                "Please select a valid date of birth",
                                Icons.warning,
                                context);
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            if (skillLevel != 0 && gender != "") {
                              _formKey.currentState!.save();
                              bool signUpSuccess = await auth.signUpWithEmail(
                                email.value!,
                                password.value!,
                                username.value!,
                                gender,
                                dateOfBirth.value,
                                skillLevel,
                                context,
                              );

                              if (signUpSuccess) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavBar(
                                              currentIndex: 0,
                                            )),
                                    (route) => false);
                              }
                            } else {
                              showCustomToast("Please fill out all fields",
                                  Icons.warning, context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(constraints.maxWidth * 0.4,
                              constraints.maxHeight * 0.08),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                color: Styles.textColor,
                                width: 1,
                              )),
                        ),
                        child: Text(
                          'CREATE',
                          style: TextStyle(
                            fontFamily: Styles.mainFont,
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxWidth * 0.06,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                    ])),
              ],
            ),
          ),
        ),
      );
    });
  }
}
