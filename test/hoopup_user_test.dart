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

  List<String> eventsLocal = [];

  group("Testing event list changing operations", () {
    test("Initial state of events list is empty", () {
      expect(userGeoff.events, []);
    });
    test("Adding one event and seeing it in the list", () {
      eventsLocal.add("event1");
      userGeoff.events = eventsLocal;
      expect(userGeoff.events, ["event1"]);
    });
    test("Adding same event multiple times should give return false", () {
      //TODO allow for add event to return true or false
      //expect(userAubrey.addEvent("event2"), true);
      //expect(userAubrey.addEvent("event2"), false);
      eventsLocal.add("event2");
      eventsLocal.add("event2");
      userGeoff.events = eventsLocal;
      expect(userAubrey.events, ["event2"]);
    });

    test("Removing an event from a user", () {
      //TODO rerenovate this shit
      expect(userGeoff.events, ["event1"]);
      //userGeoff.removeEvent("event1");
      expect(userGeoff.events, []);
    });
    test(
        "Removing and adding events in different orders seeing if it's consistent in the end",
        () {
      expect(userGeoff.events, []);
      eventsLocal.add("event1");
      userGeoff.events = eventsLocal;
      eventsLocal.add("event2");
      userGeoff.events = eventsLocal;
      eventsLocal.add("event3");
      userGeoff.events = eventsLocal;
      eventsLocal.add("event4");
      userGeoff.events = eventsLocal;
      //userGeoff.removeEvent("event2");
      expect(userGeoff.events, [
        "event1",
        "event3",
        "event4",
      ]);
      eventsLocal.add("event2");
      userGeoff.events = eventsLocal;
      //userGeoff.removeEvent("event1");
      expect(userGeoff.events, ["event3", "event4", "event2"]);
      //userGeoff.removeEvent("event2");
      //userGeoff.removeEvent("event4");
      //userGeoff.removeEvent("event3");
      expect(userGeoff.events, []);
    });
    test("Removing the same event twice should return false", () {
      expect(userAubrey.events, ["event2"]);
      //userGeoff.removeEvent("event2");
      //userGeoff.removeEvent("event2");
      expect(userAubrey.events, []);
    });
  });

  group("Testing equalisation, toString, hashing and validation functions",
      () {});
}
