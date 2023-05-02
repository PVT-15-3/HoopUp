import 'package:flutter/material.dart';
import 'package:my_app/handlers/login_handler.dart';
import 'package:provider/provider.dart';
import '../providers/firebase_provider.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late final FirebaseProvider firebaseProvider;

  @override
  Widget build(BuildContext context) {
    firebaseProvider = context.read<FirebaseProvider>();
    String? email;
    String? password;
    final Auth auth = Auth(firebaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
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
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  auth.signInWithEmail(email!, password!, context.read());
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              child: const Text('Forgot Password'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final formKey = GlobalKey<FormState>();
                    final emailController = TextEditingController();

                    return AlertDialog(
                      title: const Text("Forgot Password"),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Submit"),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              auth.resetPassword(emailController.text);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
