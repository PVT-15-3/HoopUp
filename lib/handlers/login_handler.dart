import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import '../handlers/firebase_handler.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpWithEmail(String email, String password, String username,
      HoopUpUserProvider hoopUpUserProvider) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      HoopUpUser hoopUpuser = HoopUpUser(
        username: username,
        skillLevel: 0,
        id: userCredential.user!.uid,
        photoUrl: null,
        gender: 'other',
      );
      hoopUpuser.addUserToDatabase();

      hoopUpUserProvider.setUser(hoopUpuser);

      print('User created: ${userCredential.user!.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: 'Failed to create user: ${e.message}');
    }
  }

  Future<bool> signInWithEmail(String email, String password,
      HoopUpUserProvider hoopUpUserProvider) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      Map? userMap = await getMapFromFirebase('users', user!.uid);

      HoopUpUser hoopUpuser = HoopUpUser(
        username: userMap['username'] ?? 'unknown',
        skillLevel: userMap['skillLevel'] ?? 0,
        id: user.uid,
        photoUrl: userMap['photoUrl'],
        gender: userMap['gender'] ?? 'other',
      );

      List<dynamic> dynamicList =
          await getListFromFirebase('users/${hoopUpuser.id}', "events");
      List<String> eventsList =
          List<String>.from(dynamicList.map((event) => event.toString()));
      hoopUpuser.events = eventsList;
      hoopUpUserProvider.setUser(hoopUpuser);
      print('User signed in: ${user.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: 'Failed to sign in user: ${e.message}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } on FirebaseException catch (e) {
      throw AuthException(
          message:
              'Failed to send password reset email to $email: ${e.toString()}');
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});

  @override
  String toString() {
    return 'AuthException: $message';
  }
}
