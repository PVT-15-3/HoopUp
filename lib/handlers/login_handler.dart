import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/widgets/toaster.dart';

class Auth {
  final FirebaseProvider _firebaseProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Auth(FirebaseProvider firebaseProvider)
      : _firebaseProvider = firebaseProvider;

  Future<bool> signUpWithEmail(String email, String password, String username,
      String gender, DateTime dateOfBirth, int skillLevel, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      HoopUpUser hoopUpuser = HoopUpUser(
        username: username,
        skillLevel: skillLevel,
        id: userCredential.user!.uid,
        photoUrl: "",
        gender: gender,
        dateOfBirth: dateOfBirth,
        firebaseProvider: _firebaseProvider,
      );
      hoopUpuser.addUserToDatabase();

      debugPrint('User created: ${userCredential.user!.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      Toaster.showCustomToast(e.message!, Icons.error, context);
      return false;
    }
  }

  Future<bool> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      HoopUpUser hoopUpUser =
          await _firebaseProvider.getUserFromFirebase(user!.uid);
      debugPrint('User signed in: ${hoopUpUser.username}');
      return true;
    } on FirebaseAuthException catch (e) {
      Toaster.showCustomToast(e.message!, Icons.error, context);
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email');
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
