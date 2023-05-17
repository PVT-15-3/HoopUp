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
    generateStars();
  }

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
  Widget build(BuildContext context) {
    final isEmailValid = useState(true);
    final email = useState<String?>(null);
    final password = useState<String?>(null);
    final username = useState<String?>(null);
    final dateOfBirth = useState<DateTime>(DateTime(0));

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
              const Image(
                image: AssetImage('assets/logo.png'),
                width: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "CREATE ACCOUNT",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: Styles.mainFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),

              Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                              textStyle: const TextStyle(
                                fontFamily: Styles.mainFont,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.white,
                              minimumSize: const Size(90, 50),
                              elevation: 5,
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
                        const SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = "Female";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontFamily: Styles.mainFont,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.white,
                              minimumSize: const Size(90, 50),
                              elevation: 5,
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
                        const SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = "Other";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontFamily: Styles.mainFont,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.white,
                              minimumSize: const Size(90, 50),
                              elevation: 5,
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
                      ],
                    ),
                    const SizedBox(height: 20),

                    //Edit User name ------------------------------------------
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                      ),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username*',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12)),
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
                    const SizedBox(height: 20),

                    //Edit age -------------------------------------------------
                    TextField(
                      controller: birthdayController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date of birth*',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12)),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          _selectedDate = pickedDate;
                          setState(() {
                            dateOfBirth.value = pickedDate;
                          });
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(_selectedDate);
                          birthdayController.text = formattedDate;
                        } else {
                          showCustomToast("Pick a date",
                              Icons.warning_amber_outlined, context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
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
                    const SizedBox(height: 20),

                    //Edit password ------------------------------------------------
                    TextFormField(
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                    const SizedBox(height: 20),

                    //SaveButton ---------------------------------------------------
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          DateTime thresholdDate = DateTime.now()
                              .subtract(const Duration(days: 13 * 365));
                          if (dateOfBirth.value.isAfter(thresholdDate)) {
                            showCustomToast(
                                "You must be at least 13 years old to use HoopUp",
                                Icons.warning,
                                context);
                            return;
                          }
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
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar()),
                              );
                            }
                          } else {
                            showCustomToast("Please fill out all fields",
                                Icons.warning, context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(180, 60),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Styles.textColor,
                              width: 1,
                            )),
                      ),
                      child: const Text(
                        'CREATE',
                        style: TextStyle(
                          fontFamily: Styles.mainFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
