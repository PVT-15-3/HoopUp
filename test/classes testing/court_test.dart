import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/address.dart';
import 'package:my_app/classes/court.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/time.dart';
import 'package:my_app/providers/firebase_provider.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late Court sut;
  late Event event1;
  late Event event2;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  arrangeCourt() {
    sut = Court(
        name: "Court 1",
        imageLink: "http://example.com/image.png",
        courtType: 'Indoor',
        address: Address('123 Main St', 'Springfield', 12345, 0, 0),
        numberOfHoops: 2,
        position: const LatLng(0.0, 0.0));
  }

  arrangeEvents() {
    event1 = Event(
        name: 'event1',
        description: "description1",
        creatorId: "creatorId1",
        time: Time(
            startTime: DateTime.now().add(const Duration(hours: 1)),
            endTime: DateTime.now().add(const Duration(hours: 2))),
        courtId: "courtId1",
        skillLevel: 1,
        playerAmount: 2,
        genderGroup: "any",
        ageGroup: "18-25",
        id: "id1",
        firebaseProvider: mockDatabase);

    event2 = Event(
        name: 'event2',
        description: "description2",
        creatorId: "creatorId2",
        time: Time(
            startTime: DateTime.now().add(const Duration(hours: 2)),
            endTime: DateTime.now().add(const Duration(hours: 3))),
        courtId: "courtId2",
        skillLevel: 1,
        playerAmount: 2,
        genderGroup: "femlae",
        ageGroup: "25-40",
        id: "id2",
        firebaseProvider: mockDatabase);
  }

  group('Court tests', () {
    test('Court object should be created correctly', () {
      arrangeCourt();

      expect(sut.name, 'Court 1');
      expect(sut.imageLink, 'http://example.com/image.png');
      expect(sut.courtType, 'Indoor');
      expect(sut.address.street, '123 Main St');
      expect(sut.numberOfHoops, 2);
      expect(sut.position.latitude, 0.0);
      expect(sut.position.longitude, 0.0);
      expect(sut.isSelected, false);
      expect(sut.events, []);
      expect(sut.courtId, '0.00.0');
    });

    test('Court setters should update properties correctly', () {
      arrangeCourt();

      sut.name = 'New Court Name';
      expect(sut.name, 'New Court Name');

      sut.imageLink = 'http://example.com/new_image.png';
      expect(sut.imageLink, 'http://example.com/new_image.png');

      sut.courtType = 'Outdoor';
      expect(sut.courtType, 'Outdoor');

      final newAddress = Address('456 Elm St', 'Shelbyville', 54321, 1, 1);
      sut.address = newAddress;
      expect(sut.address.street, '456 Elm St');
      expect(sut.address.city, 'Shelbyville');
      expect(sut.address.postalCode, 54321);
      expect(sut.address.long, 1);
      expect(sut.address.lat, 1);
    });

    test('addEvent() should add event to events list', () {
      arrangeCourt();
      arrangeEvents();

      sut.addEvent(event1);
      expect(sut.events.length, 1);
      expect(sut.events.first.id, 'id1');
    });

    test(
        'Removing an event from the court should remove it from the events list',
        () {
      arrangeCourt();
      arrangeEvents();

      sut.addEvent(event1);
      expect(sut.events, contains(event1));
      sut.removeEvent(event1);
      expect(sut.events, isNot(contains(event1)));
    });
    test("The toString method should return the expected string", () {
      arrangeCourt();
      arrangeEvents();

      expect(sut.toString(), equals('Court: Court 1, Indoor, ${sut.courtId}'));
    });
    test(
        'The == operator should return true for two objects with the same _courtId value and false otherwise',
        () {
      final court1 = Court(
        name: 'Test Court',
        imageLink: 'testImageLink',
        courtType: 'testCourtType',
        address: Address('123 Main St', 'Springfield', 12345, 0, 0),
        numberOfHoops: 2,
        position: const LatLng(0, 0),
      );
      final court2 = Court(
        name: 'Test Court 2',
        imageLink: 'testImageLink2',
        courtType: 'testCourtType2',
        address: Address('123 Main St', 'Springfield', 11115, 5, 5),
        numberOfHoops: 3,
        position: const LatLng(1, 1),
      );
      final court3 = Court(
        name: 'Test Court',
        imageLink: 'testImageLink',
        courtType: 'testCourtType',
        address: Address('123 Main St', 'Springfield', 12345, 0, 0),
        numberOfHoops: 2,
        position: const LatLng(0, 0),
      );
      expect(court1 == court2, isFalse);
      expect(court1 == court3, isTrue);
    });
    test(
        "Testing that the isSelected property is initially false and can be set to true.",
        () {
      // Check that the isSelected property is initially false
      expect(sut.isSelected, isFalse);

      // Set the isSelected property to true and check that it has been updated
      sut.isSelected = true;
      expect(sut.isSelected, isTrue);
    });
    test(
        "Testing that the events list is initially empty and can be populated with events.",
        () {
      expect(sut.events.isEmpty, isTrue);

      sut.addEvent(event1);
      expect(sut.events, contains(event1));

      sut.addEvent(event2);
      expect(sut.events, contains(event2));
    });
  });
}
