import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/services/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  var googleUserNew =
      ((await FirebaseAuth.instance.signInWithCredential(credential)).user);

  String? name = googleUserNew?.displayName;
  String? email = googleUserNew?.email;
  String uid = googleUserNew!.uid;

  if (email == null || name == null) {
    throw Exception("email or name or id is null");
  }

  HoopUpUser user = HoopUpUser(
      username: name, skillLevel: 0, id: uid, photoUrl: googleUserNew.photoURL);

  // Update the user object in the UserProvider
  Provider.of<HoopUpUserProvider>(context, listen: false).setUser(user);

  await GoogleSignIn().signOut();
}

Future<void> signUpWithEmail(String email, String password, String username,
    BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    String uid = user!.uid;
    HoopUpUser hoopUpuser =
        HoopUpUser(username: username, skillLevel: 0, id: uid, photoUrl: null);

    // Update the user object in the UserProvider
    Provider.of<HoopUpUserProvider>(context, listen: false).setUser(hoopUpuser);

    print(hoopUpuser);
    print('User created: ${user.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to create user: ${e.message}');
  }
}

Future<void> signInWithEmail(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('User signed in: ${user?.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to sign in user: ${e.message}');
  }
}
