import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/services/hoopup_user_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signInWithGoogle(HoopUpUserProvider hoopUpUserProvider) async {
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
      ((await _auth.signInWithCredential(credential)).user);

  String? name = googleUserNew?.displayName;
  String uid = googleUserNew!.uid;

  if (name == null) {
    throw Exception("name is null");
  }

  HoopUpUser user = HoopUpUser(
      username: name, skillLevel: 0, id: uid, photoUrl: googleUserNew.photoURL, gender: 'none');

  // Update the user object in the UserProvider
  hoopUpUserProvider.setUser(user);

  await GoogleSignIn().signOut();
}

//////////////////////////////////////////// EMAIL SIGN IN  ////////////////////////////////////////////

Future<void> signUpWithEmail(
  String email,
  String password,
  String username,
  HoopUpUserProvider hoopUpUserProvider,
) async {
  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    HoopUpUser hoopUpuser = HoopUpUser(
        username: username,
        skillLevel: 0,
        id: userCredential.user!.uid,
        photoUrl: null,
        gender: 'none'
        );
    hoopUpUserProvider.setUser(hoopUpuser);
    print('User created: ${userCredential.user!.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to create user: ${e.message}');
  }
}

Future<void> signInWithEmail(String email, String password) async {
  try {
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('User signed in: ${user?.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to sign in user: ${e.message}');
  }
}

 Future<void> resetPassword(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
  print('Password reset email sent to $email');
}
