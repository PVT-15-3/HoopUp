import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  late HoopUpUserProvider userProvider;

  setUp(() {
    userProvider = HoopUpUserProvider();
  });

  void arrangeRealUser() {
    userProvider.setUser(HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "id1",
        photoUrl: "",
        gender: "Male"));
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => userProvider,
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets("All relevant userinformation is on the page once",
      (WidgetTester tester) async {
    arrangeRealUser();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("Geoff"), findsOneWidget);
    expect(find.text("Skill level"), findsOneWidget);
    expect(find.text("Gender"), findsOneWidget);
    expect(find.text("Age"), findsOneWidget);
  });
}
