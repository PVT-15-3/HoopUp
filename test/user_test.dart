import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  group('User tests', () {
    test('create user', () async {
      // Arrange
      final user = User(
        username: 'testuser',
        skillLevel: 3,
        email: 'testuser@example.com',
      );

      // Assert
      expect(user.username == 'testuser', true);
    });
  });
}
