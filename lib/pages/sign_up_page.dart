import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_app/widgets/toaster.dart';
import 'package:provider/provider.dart';
import '../handlers/login_handler.dart';
import '../providers/firebase_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class SignUpPage extends HookWidget {
  SignUpPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = context.read<FirebaseProvider>();
    final isEmailValid = useState(true);
    final email = useState<String?>(null);
    final password = useState<String?>(null);
    final username = useState<String?>(null);
    final Auth auth = Auth(firebaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    isEmailValid.value ? null : 'Please enter a valid email',
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final isValid =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                isEmailValid.value = isValid;
                return isValid ? null : 'Please enter a valid email';
              },
              onSaved: (value) {
                email.value = value;
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
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              onSaved: (value) {
                password.value = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
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
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  bool signUpSuccess = await auth.signUpWithEmail(
                    email.value!,
                    password.value!,
                    username.value!,
                  );
                  if (signUpSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBar()),
                    );
                  } else {
                    showCustomToast("Something went wrong, try again",
                        Icons.error, context);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
