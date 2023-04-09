// is used to sign in a user, signInWithGoogle() returns a user.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/services/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  final BuildContext currentContext = context;
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
  Provider.of<HoopUpUserProvider>(currentContext, listen: false).setUser(user);

  await GoogleSignIn().signOut();
}
