import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/services/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

Future <void> main() async {
  // init database
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  group('User tests', () {
    test('create user', () async {
      // Arrange
      var user = HoopUpUser(username: "username", skillLevel: 3, id: "email@asd.com", photoUrl: null, gender: 'none');

      // Assert
      expect(user.username == "username", true);
    });
  });
}
