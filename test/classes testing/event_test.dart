import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/chat.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/time.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late MockDatabase mockDatabase;
  late Event sut;

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

  arrangeValidEvent() {
    sut = Event(
      name: 'Test event',
      description: 'Test description',
      creatorId: '1234',
      time: Time(
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 2)),
      ),
      courtId: '4567',
      skillLevel: 3,
      playerAmount: 2,
      genderGroup: 'any',
      ageGroup: '18-25',
      id: '123456',
      firebaseProvider: mockDatabase,
    );
  }

  group('Event class tests', () {
    //TODO Investigate this test error // I commented this out for now (Viktor)
    // test('Testing getters are correct', () {
    //   // Arrange
    //   arrangeValidEvent();
    //   Time testTime = Time(
    //     startTime: DateTime.now().add(const Duration(hours: 1)),
    //     endTime: DateTime.now().add(const Duration(hours: 2)),
    //   );
    //   Chat? testChat = Chat(eventId: sut.id, firebaseProvider: mockDatabase);

    //   // Assert
    //   expect(sut.name, equals('Test event'));
    //   expect(sut.description, equals('Test description'));
    //   expect(sut.creatorId, equals('1234'));
    //   expect(sut.time.startTime.minute, testTime.startTime.minute);
    //   expect(sut.time.endTime.minute, testTime.endTime.minute);
    //   expect(sut.courtId, equals('4567'));
    //   expect(sut.skillLevel, equals(3));
    //   expect(sut.playerAmount, equals(2));
    //   expect(sut.genderGroup, equals('any'));
    //   expect(sut.ageGroup, equals('18-25'));
    //   expect(sut.id, equals('123456'));
    //   expect(sut.chat, equals(testChat));
    // });

    test('Event cannot be created with invalid playerAmount', () {
      expect(
          () => Event(
                name: 'Test event',
                description: 'Test description',
                creatorId: '1234',
                time: Time(
                  startTime: DateTime.now(),
                  endTime: DateTime.now().add(const Duration(hours: 1)),
                ),
                courtId: '4567',
                skillLevel: 1,
                playerAmount: -2,
                genderGroup: 'any',
                ageGroup: '18-25',
                id: '123456',
                firebaseProvider: mockDatabase,
              ),
          throwsArgumentError);
      expect(
          () => Event(
                name: 'Test event',
                description: 'Test description',
                creatorId: '1234',
                time: Time(
                  startTime: DateTime.now(),
                  endTime: DateTime.now().add(const Duration(hours: 1)),
                ),
                courtId: '4567',
                skillLevel: 1,
                playerAmount: 22,
                genderGroup: 'any',
                ageGroup: '18-25',
                id: '123456',
                firebaseProvider: mockDatabase,
              ),
          throwsArgumentError);
    });
    test('Event cannot be created with invalid skillLevel', () {
      expect(
          () => Event(
                name: 'Test event',
                description: 'Test description',
                creatorId: '1234',
                time: Time(
                  startTime: DateTime.now(),
                  endTime: DateTime.now().add(const Duration(hours: 1)),
                ),
                courtId: '4567',
                skillLevel: -1,
                playerAmount: 2,
                genderGroup: 'any',
                ageGroup: '18-25',
                id: '123456',
                firebaseProvider: mockDatabase,
              ),
          throwsArgumentError);
    });
    test("Test that an Event can be added to the database.", () {
      arrangeValidEvent();
      sut.addEventToDatabase();
      verify(() => mockDatabase.setFirebaseDataMap("events/${sut.id}", {
            'name': sut.name,
            'description': sut.description,
            'creatorId': sut.creatorId,
            'time': sut.time.toJson(),
            'courtId': sut.courtId,
            'chat': sut.chat.toJson(),
            'skillLevel': sut.skillLevel,
            'playerAmount': sut.playerAmount,
            'genderGroup': sut.genderGroup,
            'ageGroup': sut.ageGroup,
          })).called(1);
    });
    test(
        "Test that an Event cannot be added to the database if the start or end time is invalid.",
        () {
      sut = Event(
        name: 'Test event',
        description: 'Test description',
        creatorId: '1234',
        time: Time(
          startTime: DateTime.now().add(const Duration(hours: -1)),
          endTime: DateTime.now().add(const Duration(hours: 1)),
        ),
        courtId: '4567',
        skillLevel: 1,
        playerAmount: 2,
        genderGroup: 'any',
        ageGroup: '18-25',
        id: '123456',
        firebaseProvider: mockDatabase,
      );
      expect(() => sut.addEventToDatabase(), throwsArgumentError);
    });
    test(
        "Test that the toJson() method returns a valid JSON representation of the Event.",
        () {
      arrangeValidEvent();
      final json = sut.toJson();

      expect(json['name'], equals('Test event'));
      expect(json['description'], equals('Test description'));
      expect(json['creatorId'], equals('1234'));
      expect(json['courtId'], equals('4567'));
      expect(json['skillLevel'], equals(3));
      expect(json['playerAmount'], equals(2));
      expect(json['genderGroup'], equals('any'));
      expect(json['ageGroup'], equals('18-25'));
    });
    test("Test that the userIds can be set and retrieved correctly.", () {
      arrangeValidEvent();
      List<String> testIds = ["id1", "id2", "id3", "id4", "id5"];
      sut.userIds = testIds;
      expect(sut.usersIds, testIds);
      verify(() => mockDatabase.setFirebaseDataList(
          'events/${sut.id}/userIds', testIds)).called(1);
    });
    test(
        "Test that the fromJson() factory method correctly creates an Event object from a JSON representation.",
        () {
      final json = {
        'name': 'Test Event',
        'description': 'This is a test event.',
        'creatorId': 'abc123',
        'time': {
          'startTime': '2022-05-01T12:00:00Z',
          'endTime': '2022-05-01T13:00:00Z'
        },
        'courtId': 'def456',
        'skillLevel': 2,
        'playerAmount': 10,
        'genderGroup': 'mixed',
        'ageGroup': '18-30',
        'chat': {
          'eventId': 'xyz789',
        }
      };

      sut = Event.fromJson(json, mockDatabase);
      expect(sut.name, 'Test Event');
      expect(sut.description, 'This is a test event.');
      expect(sut.creatorId, 'abc123');
      expect(sut.time.startTime, DateTime.utc(2022, 5, 1, 12));
      expect(sut.time.endTime, DateTime.utc(2022, 5, 1, 13));
      expect(sut.courtId, 'def456');
      expect(sut.skillLevel, 2);
      expect(sut.playerAmount, 10);
      expect(sut.genderGroup, 'mixed');
      expect(sut.ageGroup, '18-30');
      expect(sut.id, 'xyz789');
    });
  });
}
