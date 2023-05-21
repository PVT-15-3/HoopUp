import 'package:flutter/material.dart';
import 'package:my_app/pages/sign_up_page.dart';
import '../providers/firebase_provider.dart';
import 'login_page.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late final FirebaseProvider firebaseProvider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(
                constraints.maxWidth * 0.15, 0, constraints.maxWidth * 0.15, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //HoopUp Icon
                Image(
                  image: const AssetImage('assets/logo.png'),
                  width: constraints.maxWidth * 0.6,
                ),
                SizedBox(height: constraints.maxHeight * 0.03),

                //LOG IN
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(constraints.maxWidth * 0.25,
                        constraints.maxHeight * 0.1),
                    padding: const EdgeInsets.fromLTRB(52, 20, 52, 20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),

                //Create account
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(constraints.maxWidth * 0.25,
                          constraints.maxHeight * 0.1),
                      elevation: 5,
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  child: const Text(
                    'CREATE\nACCOUNT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
      );
    });
  }
}
