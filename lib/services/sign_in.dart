// is used to sign in a user, signInWithGoogle() returns a user.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/classes/hoopup_user.dart';

Future<HoopUpUser> signInWithGoogle() async {
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

  HoopUpUser user = HoopUpUser(username: name, skillLevel: 0, id: uid);

  await GoogleSignIn().signOut();

  return user;
}
