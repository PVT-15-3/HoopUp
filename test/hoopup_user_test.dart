import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/hoopup_user.dart';

void main() {
  late HoopUpUser userGeoff;
  late HoopUpUser userGeoffClone;
  late HoopUpUser userAubrey;

  setUp(() {
    userGeoff = HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "id1",
        photoUrl: "https://i.redd.it/gjymk14blvua1.jpg",
        gender: "Male");
    userGeoffClone = HoopUpUser(
        username: "Geoff",
        skillLevel: 5,
        id: "id1",
        photoUrl: "https://i.redd.it/gjymk14blvua1.jpg",
        gender: "Male");
    userAubrey = HoopUpUser(
        username: "Aubrey",
        skillLevel: 3,
        id: "id2",
        photoUrl: "https://i.redd.it/m3769x8h0py81.jpg",
        gender: "Female");
  });

  group("Testing event list changing operations", () {
    test("Initial state of events list is empty", () {
      expect(userGeoff.events, []);
    });
    test("Adding one event and seeing it in the list", () {
      userGeoff.addEvent("event1");
      expect(userGeoff.events, ["event1"]);
    });
    test("Adding same event multiple times should give return false", () {
      //TODO allow for add event to return true or false
      //expect(userAubrey.addEvent("event2"), true);
      //expect(userAubrey.addEvent("event2"), false);
      userAubrey.addEvent("event2");
      userAubrey.addEvent("event2");
      expect(userAubrey.events, ["event2"]);
    });

    test("Removing an event from a user", () {});
    test(
        "Removing and adding events in different orders seeing if it's consistent in the end",
        () {});
    test("Removing the same event twice should return false", () => null);
  });

  group("Testing equalisation, toString, hashing and validation functions",
      () {});
}
