import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late HoopUpUser sut;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    when(() => mockDatabase.setFirebaseDataMap(any(), any()))
        .thenAnswer((_) async {
      await Future.delayed(Duration.zero);
      return Future.value(null);
    });
    when(() => mockDatabase.updateFirebaseData(any(), any()))
        .thenAnswer((_) async {
      await Future.delayed(Duration.zero);
      return Future.value(null);
    });
    when(() => mockDatabase.setFirebaseDataList(any(), any()))
        .thenAnswer((_) async {
      await Future.delayed(Duration.zero);
      return Future.value(null);
    });
    when(() => mockDatabase.removeFirebaseData(any())).thenAnswer((_) async {
      await Future.delayed(Duration.zero);
      return Future.value(null);
    });
  });

  void arrangeRealUser() {
    sut = HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "creatorId",
        photoUrl: "",
        gender: "Male",
        firebaseProvider: mockDatabase,
        age: 18);
  }

  group("Testing constructor", () {
    test(
        "Test the constructor with valid arguments and verify that the object is created successfully.",
        () {
      arrangeRealUser();
      // Verify that the object was created successfully
      expect(sut.username, 'Geoff');
      expect(sut.skillLevel, 5);
      expect(sut.id, 'creatorId');
      expect(sut.photoUrl, "");
      expect(sut.gender, "Male");
    });
    test(
        "Test the constructor with an invalid skill level argument (less than 0 or greater than 5) and verify that it throws an ArgumentError.",
        () {
      expect(
          () => HoopUpUser(
              username: 'John',
              skillLevel: -1,
              id: '123',
              photoUrl: null,
              gender: "",
              firebaseProvider: mockDatabase,
              age: 18),
          throwsArgumentError);
    });
  });

  group("Test database communications functions", () {
    test(
        "Test the addUserToDatabase() method and verify that it calls the appropriate Firebase methods to store the user data.",
        () {
      arrangeRealUser();
      sut.addUserToDatabase();
      verify(() => mockDatabase.setFirebaseDataMap("users/${sut.id}", {
            "username": sut.username,
            "skillLevel": sut.skillLevel,
            "photoUrl": sut.photoUrl,
            "gender": sut.gender
          })).called(1);
    });
    group(
        "Test the setters (photoUrl, gender, username, skillLevel, and events) and verify that they update the appropriate user properties and call the appropriate Firebase methods to update the data.",
        () {
      test("Testing setter photoUrl", () {
        arrangeRealUser();
        sut.photoUrl = "TestingUrl";
        expect(sut.photoUrl, "TestingUrl");
        verify(() => mockDatabase.updateFirebaseData(
            "users/${sut.id}", {"photoUrl": sut.photoUrl})).called(1);
      });
      test("Testing setter gender", () {
        arrangeRealUser();
        sut.gender = "TestingGender";
        expect(sut.gender, "TestingGender");
        verify(() => mockDatabase.updateFirebaseData(
            "users/${sut.id}", {"gender": sut.gender})).called(1);
      });
      test("Testing setter username", () {
        arrangeRealUser();
        sut.username = "TestingUsername";
        expect(sut.username, "TestingUsername");
        verify(() => mockDatabase.updateFirebaseData(
            "users/${sut.id}", {"username": sut.username})).called(1);
      });
      test("Testing setter skillLevel", () {
        arrangeRealUser();
        sut.skillLevel = 5;
        expect(sut.skillLevel, 5);
        verify(() => mockDatabase.updateFirebaseData(
            "users/${sut.id}", {"skillLevel": sut.skillLevel})).called(1);
      });
      test(
          "Testing setter skillLevel and verifying validateSkillevel() throws exception",
          () {
        arrangeRealUser();
        expect(() => sut.skillLevel = -1, throwsArgumentError);
      });
      test("Testing setter events", () {
        arrangeRealUser();
        sut.events = ["eventId1", "eventId2", "eventId3"];
        expect(sut.events, ["eventId1", "eventId2", "eventId3"]);
        verify(() => mockDatabase.setFirebaseDataList(
                'users/${sut.id}/events', ["eventId1", "eventId2", "eventId3"]))
            .called(1);
      });
    });
  });
  group("Testing toJson(), toString() and equality operator", () {
    test("Testing toJson()", () {
      arrangeRealUser();
      expect(sut.toJson(), {
        'username': sut.username,
        'gender': sut.gender,
        'skillLevel': sut.skillLevel,
        'id': sut.id,
        'photoUrl': sut.photoUrl
      });
    });
    test("Testing toString()", () {
      arrangeRealUser();
      expect(sut.toString(),
          "User: ${sut.username}, ${sut.gender}, ${sut.skillLevel}, ${sut.id}, ${sut.photoUrl}, ${sut.events}");
    });
    test("Testing equality operator", () {
      arrangeRealUser();
      HoopUpUser otherUser = HoopUpUser(
          username: 'John',
          skillLevel: 3,
          id: '123',
          photoUrl: null,
          gender: "",
          firebaseProvider: mockDatabase,
          age: 18);
      HoopUpUser identicalUser = HoopUpUser(
          username: "Geoff",
          skillLevel: 5,
          id: "creatorId",
          photoUrl: "",
          gender: "Male",
          firebaseProvider: mockDatabase,
          age: 18);
      expect(otherUser == sut, false);
      expect(identicalUser == sut, true);
    });
  });
}
