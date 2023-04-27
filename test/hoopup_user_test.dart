import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/classes/hoopup_user.dart';

class MockUser extends Mock implements HoopUpUser {}

void main() {
  final HoopUpUser user1 = MockUser();
  final HoopUpUser user2 = MockUser();
  final HoopUpUser user3 = MockUser();

  setUp(() {
    when(() => user1.username).thenReturn("Geoff");
    when(() => user1.skillLevel).thenReturn(5);
    when(() => user1.gender).thenReturn("Male");
    when(() => user1.id).thenReturn("id1");
    when(() => user1.photoUrl)
        .thenReturn("https://i.redd.it/gjymk14blvua1.jpg");

    when(() => user2.username).thenReturn("Kim");
    when(() => user2.skillLevel).thenReturn(1);
    when(() => user2.gender).thenReturn("Other");
    when(() => user2.id).thenReturn("id2");
    when(() => user2.photoUrl)
        .thenReturn("https://i.redd.it/lxiaa9ofd1271.png");

    when(() => user3.username).thenReturn("Aubrey");
    when(() => user3.skillLevel).thenReturn(2);
    when(() => user3.gender).thenReturn("Female");
    when(() => user3.id).thenReturn("id3");
    when(() => user3.photoUrl)
        .thenReturn("https://i.redd.it/m3769x8h0py81.jpg");
  });

  //tests
  group("Testing variables", () {
    test("Testing usernames", () async {
      expect(user1.username, "Geoff");
      expect(user2.username, "Kim");
      expect(user3.username, "Aubrey");
    });
  });
}
