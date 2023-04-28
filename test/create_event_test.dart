import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/classes/time.dart';
import 'package:my_app/pages/create_event.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  late HoopUpUserProvider userProvider;
  late Event compareEvent;

  setUp(() {
    userProvider = HoopUpUserProvider();
    compareEvent = Event(
        name: "event",
        description: "description",
        creatorId: "creatorId",
        time: Time(
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 1))),
        courtId: "courtId",
        skillLevel: 5,
        playerAmount: 6,
        genderGroup: "All",
        ageGroup: "13-17",
        id: "id");
  });

  void arrangeRealUser() {
    userProvider.setUser(HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "creatorId",
        photoUrl: "",
        gender: "Male"));
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => userProvider,
        child: const CreateEventPage(),
      ),
    );
  }

  group("All relevant create event information is on the page", () {
    testWidgets("Start time exists and is now", (WidgetTester tester) async {
      DateTime time = DateTime.now();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("${time.hour}:${time.minute}"), findsOneWidget);
    });
    testWidgets("End time exists and is now plus 1 hour ahead",
        (WidgetTester tester) async {
      DateTime time = DateTime.now().add(const Duration(hours: 1));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("${time.hour}:${time.minute}"), findsOneWidget);
    });
    testWidgets("Event name exists and is correct",
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      //expect(find.text(text), matcher)
    });
  });

  group("Assurance tests", () {
    testWidgets("Assure created event is the same as test event",
        (WidgetTester tester) async {});
  });
}
