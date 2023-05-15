import 'package:flutter/material.dart';
import 'package:my_app/pages/sign_up_page.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import '../providers/firebase_provider.dart';
import 'login_page.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late final FirebaseProvider firebaseProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(100, 0, 100, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //HoopUp Icon
              const Image(
                image: AssetImage('assets/logo.png'),
                width: 200,
              ),
              const SizedBox(height: 20),

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
                  minimumSize: const Size(100, 52),
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
              const SizedBox(height: 20),

              //Create account
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(100, 52),
                    elevation: 5,
                    padding: const EdgeInsets.fromLTRB(52, 20, 52, 20),
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
  }
}
