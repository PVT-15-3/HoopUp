import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/classes/message.dart';
import 'package:my_app/providers/firebase_provider.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late Message sut1;
  late Message sut2;
  late HoopUpUser user1;
  late HoopUpUser user2;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  arrangeUsers() {
    user1 = HoopUpUser(
        username: "user1",
        skillLevel: 1,
        id: "id",
        photoUrl: "photoUrl",
        gender: "gender",
        firebaseProvider: mockDatabase,
        age: 18);
    user2 = HoopUpUser(
        username: "user2",
        skillLevel: 1,
        id: "id",
        photoUrl: "photoUrl",
        gender: "gender",
        firebaseProvider: mockDatabase,
        age: 18);
  }

  arrangeMessages() {
    sut1 = Message(
        username: user1.username,
        userId: user1.id,
        messageText:
            "I hate rats. They locked me in a room. a rubber room. A rubber room with rats.",
        timeStamp: DateTime.now());
    sut2 = Message(
        username: user2.username,
        userId: user2.id,
        messageText: "What?",
        timeStamp: DateTime.now());
  }

  group('Message', () {
    test('creates a message object with valid data', () {
      arrangeUsers();
      arrangeMessages();

      expect(sut1.username, equals('user1'));
      expect(
          sut1.messageText,
          equals(
              "I hate rats. They locked me in a room. a rubber room. A rubber room with rats."));
      expect(sut1.timeStamp, isNotNull);
    });

    test('message id is unique', () {
      arrangeUsers();
      arrangeMessages();

      expect(sut1.id != sut2.id, isTrue);
    });

    test('toJson() returns a valid JSON object', () {
      // I commented this out for now (Viktor)
      arrangeUsers();
      arrangeMessages();

      final json = sut1.toJson();

      expect(json['id'], isNotNull);
      expect(json['username'], equals('user1'));
      expect(
          json['messageText'],
          equals(
              'I hate rats. They locked me in a room. a rubber room. A rubber room with rats.'));
      expect(json['timeStamp'], isNotNull);
    });
  });
}
