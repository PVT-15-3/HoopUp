import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late HoopUpUser user;
  late HoopUpUserProvider userProvider;
  late MockDatabase firebaseProvider;

  setUp(() {
    firebaseProvider = MockDatabase();
    userProvider = HoopUpUserProvider();

    user = HoopUpUser(
        username: "Geoff",
        skillLevel: 1,
        id: "id1",
        photoUrl: "photo",
        gender: "Male",
        firebaseProvider: firebaseProvider);
    userProvider.setUser(user);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: const MaterialApp(
        home: ProfilePage(),
      ),
    );
  }

  group("Testing Profile page", () {
    testWidgets("All nessecary components are on the page",
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and Count the number of stars in the row
      final starRow = find.byType(Row);
      final stars = starRow.evaluate().single.widget as Row;
      final numStars = stars.children.length;

      expect(numStars, user.skillLevel);
      expect(find.text(user.username), findsOneWidget);
      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Year of Birth"), findsOneWidget);
      expect(find.text("Gender"), findsOneWidget);
    });
  });
}
