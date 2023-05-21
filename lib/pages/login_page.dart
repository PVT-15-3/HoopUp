import 'package:flutter/material.dart';
import 'package:my_app/handlers/login_handler.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../providers/firebase_provider.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late final FirebaseProvider firebaseProvider;

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = context.read<FirebaseProvider>();
    String? email;
    String? password;
    final Auth auth = Auth(firebaseProvider);

    return LayoutBuilder(builder: (context, constraints) {
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
            child: Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.15, 0,
                    constraints.maxWidth * 0.15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //HoopUp Icon
                    Image(
                      image: const AssetImage('assets/logo.png'),
                      width: constraints.maxWidth * 0.3,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),

                    //Login Text
                    const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),

                    //Email Text
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                      ),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: constraints.maxWidth * 0.03),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),

                    //Password Text
                    TextFormField(
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: Styles.mainFont,
                      ),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: constraints.maxWidth * 0.03),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),

                    //Submit Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          showCustomToast("Authenticating...",
                              Icons.watch_later_outlined, context);
                          bool logInSuccess = await auth.signInWithEmail(
                              email!, password!, context);
                          if (logInSuccess) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar(
                                          currentIndex: 0,
                                        )),
                                (route) => false);
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
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontFamily: Styles.mainFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
