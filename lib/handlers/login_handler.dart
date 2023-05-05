import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:my_app/providers/firebase_provider.dart';

class Auth {
  final FirebaseProvider _firebaseProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Auth(FirebaseProvider firebaseProvider)
      : _firebaseProvider = firebaseProvider;

  Future<bool> signUpWithEmail(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      HoopUpUser hoopUpuser = HoopUpUser(
        username: username,
        skillLevel: 0,
        id: userCredential.user!.uid,
        photoUrl: null,
        gender: 'other',
        firebaseProvider: _firebaseProvider,
      );
      hoopUpuser.addUserToDatabase();

      print('User created: ${userCredential.user!.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: 'Failed to create user: ${e.message}');
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      HoopUpUser hoopUpUser = await _firebaseProvider.getUserFromFirebase(user!.uid);
      print('User signed in: ${hoopUpUser.username}');
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
