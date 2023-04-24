import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/handlers/firebase_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // init database
  group('Fetch from firebase', () {
    test('fetch user', () async {
      // Arrange
      var userMap = await getMapFromFirebase('users', 'mSiBkiS2efbPEtqWsuh98Bn5kM22');

      // Assert
      expect(userMap['username'] == 'Viktor B', true);
    });
  });
}
