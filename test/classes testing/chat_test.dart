import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/chat.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/classes/message.dart';
import 'package:my_app/providers/firebase_provider.dart';

class MockDatabase extends Mock implements FirebaseProvider {}

void main() {
  late Chat sut;
  late Message message;
  late HoopUpUser user;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    user = HoopUpUser(
        username: "user",
        skillLevel: 1,
        id: "id",
        photoUrl: "photoUrl",
        gender: "gender",
        firebaseProvider: mockDatabase,
        age: 18);

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

  arrangeChat() {
    sut = Chat(eventId: 'event123', firebaseProvider: mockDatabase);
  }

  arrangeMessage() {
    message = Message(
        username: user.username,
        messageText: "messageText",
        timeStamp: DateTime.now());
  }

  group('Chat tests', () {
    test('addMessage should add a message to the chat', () {
      arrangeChat();
      arrangeMessage();

      sut.addMessage(message);

      expect(sut.messages, contains(message));
      verify(() => mockDatabase.setFirebaseDataMap(
              "events/event123/chat/messages/${message.id}", message.toJson()))
          .called(1);
    });

    test('removeMessage should remove a message from the chat', () {
      arrangeChat();
      arrangeMessage();

      sut.addMessage(message);
      sut.removeMessage(message);

      expect(sut.messages, isNot(contains(message)));
      verify(() => mockDatabase.removeFirebaseData(
          "events/event123/chat/messages/${message.id}")).called(1);
    });

    test('toJson should return a valid JSON object', () {
      arrangeChat();
      arrangeMessage();

      sut.addMessage(message);

      final json = sut.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], isNotNull);
      expect(json['eventId'], equals('event123'));
      expect(json['messages'], isA<List<dynamic>>());
      expect(json['messages'].length, equals(1));
      expect(json['messages'][0], equals(message.toJson()));
    });
  });
}
