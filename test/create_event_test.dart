import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late HoopUpUser sut;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  void arrangeRealUser() {
    sut = HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "creatorId",
        photoUrl: "",
        gender: "Male",
        firebaseProvider: mockDatabase);
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
              gender: null,
              firebaseProvider: mockDatabase),
          throwsArgumentError);
    });
  });

  group("Test database communications functions", () {
    test(
        "Test the addUserToDatabase() method and verify that it calls the appropriate Firebase methods to store the user data.",
        () {
      arrangeRealUser();
      verify(() => mockDatabase.setFirebaseDataMap("users/${sut.id}", {
            "username": sut.username,
            "skillLevel": sut.skillLevel,
            "photoUrl": sut.photoUrl,
            "gender": sut.gender
          })).called(1);
    });
  });
}
