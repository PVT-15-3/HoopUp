import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/address.dart';
import 'package:my_app/classes/court.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/classes/time.dart';
import 'package:my_app/pages/create_event_wizard.dart';
import 'package:my_app/providers/create_event_wizard_provider.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late HoopUpUser user;
  late HoopUpUserProvider userProvider;
  late MockDatabase firebaseProvider;
  late CreateEventWizardProvider wizardProvider;

  setUp(() {
    firebaseProvider = MockDatabase();
    userProvider = HoopUpUserProvider();
    wizardProvider = CreateEventWizardProvider();
    user = HoopUpUser(
        username: "Geoff",
        skillLevel: 1,
        id: "id1",
        photoUrl: "photo",
        gender: "Male",
        firebaseProvider: firebaseProvider,
        dateOfBirth: DateTime.now());
    userProvider.setUser(user);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => wizardProvider),
        ChangeNotifierProvider(create: (_) => firebaseProvider),
      ],
      child: MaterialApp(
        home: CreateEventWizard(),
      ),
    );
  }

  group("Provider testing", () {
    group("Testing getters and setters", () {
      test("Test setting and getting the event date", () {
        DateTime eventDate = DateTime(2023, 5, 23);
        wizardProvider.eventDate = eventDate;
        assert(wizardProvider.eventDate == eventDate);
      });
      test("Test setting and getting the event start time", () {
        TimeOfDay startTime = TimeOfDay(hour: 10, minute: 30);
        wizardProvider.eventStartTime = startTime;
        assert(wizardProvider.eventStartTime == startTime);
      });
      test("Test setting and getting the event end time", () {
        TimeOfDay endTime = TimeOfDay(hour: 12, minute: 30);
        wizardProvider.eventEndTime = endTime;
        assert(wizardProvider.eventEndTime == endTime);
      });
      test("Test setting and getting the number of participants", () {
        int numberOfParticipants = 5;
        wizardProvider.numberOfParticipants = numberOfParticipants;
        assert(wizardProvider.numberOfParticipants == numberOfParticipants);
      });
      test("Test setting and getting the selected gender", () {
        String selectedGender = "Male";
        wizardProvider.selectedGender = selectedGender;
        assert(wizardProvider.selectedGender == selectedGender);
      });
      test("Test setting and getting the minimum age", () {
        int minimumAge = 18;
        wizardProvider.minimumAge = minimumAge;
        assert(wizardProvider.minimumAge == minimumAge);
      });
      test("Test setting and getting the maximum age", () {
        int maximumAge = 40;
        wizardProvider.maximumAge = maximumAge;
        assert(wizardProvider.maximumAge == maximumAge);
      });
      test("Test setting and getting the skill level", () {
        int skillLevel = 3;
        wizardProvider.skillLevel = skillLevel;
        assert(wizardProvider.skillLevel == skillLevel);
      });
      test("Test setting and getting the event name", () {
        String eventName = "Event1";
        wizardProvider.eventName = eventName;
        assert(wizardProvider.eventName == eventName);
      });
      test("Test setting and getting the event description", () {
        String eventDescription = "Join us for a friendly match!";
        wizardProvider.eventDescription = eventDescription;
        assert(wizardProvider.eventDescription == eventDescription);
      });
      test("Test setting and getting the court ID", () {
        String courtId = "abc123";
        wizardProvider.courtId = courtId;
        assert(wizardProvider.courtId == courtId);
      });
      test("Test setting and getting the court", () {
        Court court = Court(
            name: "Court1",
            imageLink: "imagelink",
            courtType: "PVC",
            address: Address("StreetName", "CityName", 10110, 0, 0),
            numberOfHoops: 2,
            position: LatLng(0, 0));
        wizardProvider.court = court;
        assert(wizardProvider.court == court);
      });
      test("Test setting and getting the user ID", () {
        String userId = "user123";
        wizardProvider.userId = userId;
        assert(wizardProvider.userId == userId);
      });
      test("Test setting and getting the wizard first step map selection", () {
        bool mapSelected = true;
        wizardProvider.wizardFirstStepMapSelected = mapSelected;
        assert(wizardProvider.wizardFirstStepMapSelected == mapSelected);
      });
      test("Test setting and getting the wizard first step time selection", () {
        bool timeSelected = true;
        wizardProvider.wizardFirstStepTimeSelected = timeSelected;
        assert(wizardProvider.wizardFirstStepTimeSelected == timeSelected);
      });
      test("Test updating the selected year", () {
        int selectedYear = 2023;
        wizardProvider.setSelectedYear(selectedYear);
        assert(wizardProvider.selectedYear == selectedYear);
      });
      test("Test updating the selected month", () {
        int selectedMonth = 5;
        wizardProvider.setSelectedMonth(selectedMonth);
        assert(wizardProvider.selectedMonth == selectedMonth);
      });
      test("Test updating the selected day", () {
        int selectedDay = 23;
        wizardProvider.setSelectedDay(selectedDay);
        assert(wizardProvider.selectedDay == selectedDay);
      });
    });
    group("Testing other methods", () {
      test(
          'updateColorFirstStep should update the color based on the selected steps',
          () {
        expect(wizardProvider.color, isNull);

        wizardProvider.updateColorFirstStep(false, false);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));

        wizardProvider.updateColorFirstStep(true, true);
        expect(wizardProvider.color, equals(const Color(0xFFFC8027)));

        wizardProvider.updateColorFirstStep(true, false);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));

        wizardProvider.updateColorFirstStep(false, true);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));
      });
      test(
          'onMapSelectedChanged should update wizardFirstStepMapSelected and call updateColorFirstStep',
          () {
        // Initial values
        expect(wizardProvider.wizardFirstStepMapSelected, isFalse);
        expect(wizardProvider.color, isNull);

        // Toggle map selection to true
        wizardProvider.onMapSelectedChanged(true);
        expect(wizardProvider.wizardFirstStepMapSelected, isTrue);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));

        // Toggle map selection to false
        wizardProvider.onMapSelectedChanged(false);
        expect(wizardProvider.wizardFirstStepMapSelected, isFalse);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));
      });
      test(
          'onGenderSelectedChanged should update wizardSecondStepGenderSelected and call updateColorSecondStep',
          () {
        // Initial values
        expect(wizardProvider.wizardSecondStepGenderSelected, isFalse);
        expect(wizardProvider.color, isNull);

        // Toggle gender selection to true
        wizardProvider.onGenderSelectedChanged(true);
        expect(wizardProvider.wizardSecondStepGenderSelected, isTrue);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));

        // Toggle gender selection to false
        wizardProvider.onGenderSelectedChanged(false);
        expect(wizardProvider.wizardSecondStepGenderSelected, isFalse);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));
      });
      test(
          'onAgeSelectedChanged should update wizardSecondStepAgeGroupSelected and call updateColorSecondStep',
          () {
        // Initial values
        expect(wizardProvider.wizardSecondStepAgeGroupSelected, isFalse);
        expect(wizardProvider.color, isNull);

        // Toggle age selection to true
        wizardProvider.onAgeSelectedChanged(true);
        expect(wizardProvider.wizardSecondStepAgeGroupSelected, isTrue);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));

        // Toggle age selection to false
        wizardProvider.onAgeSelectedChanged(false);
        expect(wizardProvider.wizardSecondStepAgeGroupSelected, isFalse);
        expect(wizardProvider.color, equals(const Color(0xFF959595)));
      });
      test('updateEventDate should update eventDate', () {
        final date = DateTime(2023, 5, 24);
        wizardProvider.wizardFirstStepMapSelected = true;
        wizardProvider.selectedMonth = 5;
        wizardProvider.selectedDay = 24;
        wizardProvider.selectedYear = 2023;
        wizardProvider.updateEventDate();
        expect(wizardProvider.eventDate, equals(date));
      });
      test('isTimeOverlap should return true when there is an overlap', () {
        // Arrange
        wizardProvider.eventDate = DateTime(2023, 5, 24);
        wizardProvider.eventStartTime = TimeOfDay(hour: 10, minute: 0);
        wizardProvider.eventEndTime = TimeOfDay(hour: 12, minute: 0);

        final eventTime = Time(
          startTime: DateTime(2023, 5, 24, 11, 0),
          endTime: DateTime(2023, 5, 24, 13, 0),
        );

        // Act
        final result = wizardProvider.isTimeOverlap(eventTime);

        // Assert
        expect(result, true);
      });
      test('isTimeOverlap should return false when there is no overlap', () {
        // Arrange
        wizardProvider.eventDate = DateTime(2023, 5, 24);
        wizardProvider.eventStartTime = TimeOfDay(hour: 10, minute: 0);
        wizardProvider.eventEndTime = TimeOfDay(hour: 12, minute: 0);

        final eventTime = Time(
          startTime: DateTime(2023, 5, 24, 8, 0),
          endTime: DateTime(2023, 5, 24, 9, 0),
        );

        // Act
        final result = wizardProvider.isTimeOverlap(eventTime);

        // Assert
        expect(result, false);
      });
      test('isLeapYear should return true for a leap year', () {
        const year = 2020;
        expect(wizardProvider.isLeapYear(year), isTrue);
      });
      test('isLeapYear should return false for a non-leap year', () {
        const year = 2023;
        expect(wizardProvider.isLeapYear(year), isFalse);
      });
      test('reset should reset all properties to their default values', () {
        // Arrange
        final wizardProvider = CreateEventWizardProvider();
        wizardProvider.eventDate = DateTime(2023, 5, 24);
        wizardProvider.eventStartTime = TimeOfDay(hour: 10, minute: 0);
        wizardProvider.eventEndTime = TimeOfDay(hour: 12, minute: 0);
        wizardProvider.numberOfParticipants = 5;
        wizardProvider.selectedGender = "Male";
        wizardProvider.minimumAge = 18;
        wizardProvider.maximumAge = 40;
        wizardProvider.skillLevel = 3;
        wizardProvider.eventName = "Basketball Game";
        wizardProvider.eventDescription =
            "Join us for a friendly basketball game.";
        wizardProvider.courtId = "court_123";
        wizardProvider.userId = "user_123";
        wizardProvider.wizardFirstStepMapSelected = true;
        wizardProvider.wizardFirstStepTimeSelected = true;
        wizardProvider.wizardSecondStepGenderSelected = true;
        wizardProvider.wizardSecondStepAgeGroupSelected = true;
        wizardProvider.wizardSecondStepSkillLevelSelected = false;
        wizardProvider.selectedYear = 2023;
        wizardProvider.selectedMonth = 5;
        wizardProvider.selectedDay = 24;
        wizardProvider.selectedStartHour = 10;
        wizardProvider.selectedStartMinute = 0;
        wizardProvider.selectedEndHour = 12;
        wizardProvider.selectedEndMinute = 0;
        wizardProvider.genderAllSelected = true;
        wizardProvider.ageGroupAllSelected = true;
        wizardProvider.skillLevelAllSelected = true;
        wizardProvider.color = Colors.blue;

        // Act
        wizardProvider.reset();

        // Assert
        expect(wizardProvider.eventDate, DateTime.now());
        expect(wizardProvider.eventStartTime, TimeOfDay.now());
        expect(wizardProvider.eventEndTime, TimeOfDay.now());
        expect(wizardProvider.numberOfParticipants, 2);
        expect(wizardProvider.selectedGender, "");
        expect(wizardProvider.minimumAge, 13);
        expect(wizardProvider.maximumAge, 100);
        expect(wizardProvider.skillLevel, 1);
        expect(wizardProvider.eventName, "");
        expect(wizardProvider.eventDescription, "");
        expect(wizardProvider.courtId, "");
        expect(wizardProvider.court, null);
        expect(wizardProvider.userId, "");
        expect(wizardProvider.wizardFirstStepMapSelected, false);
        expect(wizardProvider.wizardFirstStepTimeSelected, false);
        expect(wizardProvider.wizardSecondStepGenderSelected, false);
        expect(wizardProvider.wizardSecondStepAgeGroupSelected, false);
        expect(wizardProvider.wizardSecondStepSkillLevelSelected, true);
        expect(wizardProvider.selectedYear, DateTime.now().year);
        expect(wizardProvider.selectedMonth, DateTime.now().month);
        expect(wizardProvider.selectedDay, DateTime.now().day);
        expect(wizardProvider.selectedStartHour, TimeOfDay.now().hour);
        expect(wizardProvider.selectedStartMinute, TimeOfDay.now().minute);
        expect(wizardProvider.selectedEndHour, TimeOfDay.now().hour);
        expect(wizardProvider.selectedEndMinute, TimeOfDay.now().minute);
        expect(wizardProvider.genderAllSelected, false);
        expect(wizardProvider.ageGroupAllSelected, false);
        expect(wizardProvider.skillLevelAllSelected, false);
        expect(wizardProvider.color, null);
      });
    });
  });

  // group("Widget tests", () {
  //   group("Create event wizard page tests", () {
  //     group("Tests for WizardFirstStep", () {
  //       testWidgets('Initial state of WizardFirstStep is correct',
  //           (WidgetTester tester) async {
  //         await tester.pumpWidget(createWidgetUnderTest());
  //         expect(find.text('WizardFirstStep'), findsOneWidget);
  //       });

  //       testWidgets('Input fields in WizardFirstStep update correctly',
  //           (WidgetTester tester) async {
  //         await tester.pumpWidget(createWidgetUnderTest());
  //         await tester.enterText(
  //             find.byKey(Key('usernameTextField')), 'John Doe');
  //         await tester.enterText(find.byKey(Key('skillLevelTextField')), '2');
  //         await tester.tap(find.byKey(Key('saveButton')));
  //         await tester.pump();
  //         expect(userProvider.user?.username, 'John Doe');
  //         expect(userProvider.user?.skillLevel, 2);
  //       });

  //       testWidgets('Error shown when required fields are not filled in',
  //           (WidgetTester tester) async {
  //         await tester.pumpWidget(createWidgetUnderTest());
  //         await tester.enterText(find.byKey(Key('usernameTextField')), '');
  //         await tester.enterText(find.byKey(Key('skillLevelTextField')), '');
  //         await tester.tap(find.byKey(Key('saveButton')));
  //         await tester.pump();
  //         expect(
  //             find.text('Please fill in all required fields'), findsOneWidget);
  //       });

  //       testWidgets(
  //           'User is redirected to the next step after successful completion',
  //           (WidgetTester tester) async {
  //         await tester.pumpWidget(createWidgetUnderTest());
  //         await tester.enterText(
  //             find.byKey(Key('usernameTextField')), 'John Doe');
  //         await tester.enterText(find.byKey(Key('skillLevelTextField')), '2');
  //         await tester.tap(find.byKey(Key('saveButton')));
  //         await tester.pump();
  //         expect(find.text('WizardSecondStep'), findsOneWidget);
  //       });
  //       testWidgets('Cancel button resets input fields',
  //           (WidgetTester tester) async {
  //         await tester.pumpWidget(createWidgetUnderTest());
  //         await tester.enterText(
  //             find.byKey(Key('usernameTextField')), 'John Doe');
  //         await tester.enterText(find.byKey(Key('skillLevelTextField')), '2');
  //         await tester.tap(find.byKey(Key('cancelButton')));
  //         await tester.pump();
  //         expect(find.text('John Doe'), findsNothing);
  //         expect(find.text('2'), findsNothing);
  //       });
  //     });
  //   });
  // });
}
