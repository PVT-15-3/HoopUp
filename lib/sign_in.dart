import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/user.dart' as user_file;

Future<void> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  // print users name
  var googleUserNew = ((await FirebaseAuth.instance.signInWithCredential(credential)).user);

  var name = googleUserNew?.displayName;
  var email = googleUserNew?.email;

  if(email == null || name == null) {
    throw Exception("email or name is null");
  }

  user_file.User user2 = user_file.User(username: name, skillLevel: 3, email: email);
}
