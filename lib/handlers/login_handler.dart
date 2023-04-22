import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import '../services/get_data_from_firebase.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signUpWithEmail(
  String email,
  String password,
  String username,
  HoopUpUserProvider hoopUpUserProvider,
) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    HoopUpUser hoopUpuser = HoopUpUser(
        username: username,
        skillLevel: 0,
        id: userCredential.user!.uid,
        photoUrl: null,
        gender: 'other');
    hoopUpUserProvider.setUser(hoopUpuser);
    print('User created: ${userCredential.user!.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to create user: ${e.message}');
  }
}

Future<void> signInWithEmail(String email, String password, HoopUpUserProvider hoopUpUserProvider) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    Map? userMap = await getMapFromFirebase('users', user!.uid);
    HoopUpUser hoopUpuser = HoopUpUser(
        username: userMap['username'] ?? 'unknown',
        skillLevel: userMap['skillLevel'] ?? 0,
        id: user.uid,
        photoUrl: userMap['photoUrl'],
        gender: userMap['gender'] ?? 'other');
    hoopUpUserProvider.setUser(hoopUpuser);
    print(hoopUpUserProvider.user!);

    print('User signed in: ${user.uid}');
  } on FirebaseAuthException catch (e) {
    print('Failed to sign in user: ${e.message}');
  }
}

Future<void> resetPassword(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
  print('Password reset email sent to $email');
}
