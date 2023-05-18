import 'package:my_app/classes/message.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import '../classes/hoopup_user.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/time.dart';
import 'package:uuid/uuid.dart';

class EventHandler {
  Future<void> createEvent(
      {required DateTime eventDate,
      required TimeOfDay eventStartTime,
      required TimeOfDay eventEndTime,
      required int numberOfParticipants,
      required String selectedGender,
      required String selectedAgeGroup,
      required int skillLevel,
      required String eventName,
      required String eventDescription,
      required String courtId,
      required String userId,
      required HoopUpUser? hoopUpUser,
      required FirebaseProvider firebaseProvider}) async {
    // Implementation of event creation logic goes here
    DateTime startTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventStartTime.hour,
      eventStartTime.minute,
    );
    DateTime endTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventEndTime.hour,
      eventEndTime.minute,
    );
    Time time = Time(startTime: startTime, endTime: endTime);
    Event event = Event(
      name: eventName,
      description: eventDescription,
      creatorId: userId,
      time: time,
      courtId: courtId,
      skillLevel: skillLevel,
      playerAmount: numberOfParticipants,
      genderGroup: selectedGender,
      ageGroup: selectedAgeGroup,
      id: const Uuid().v4(),
      firebaseProvider: firebaseProvider,
    );
    Message message = Message(
      username: hoopUpUser!.username,
      userId: hoopUpUser.id,
      messageText: eventDescription,
      timeStamp: DateTime.now(),
    );
    await event.addEventToDatabase();
    if(message.messageText.isNotEmpty) {
      await event.chat.addMessage(message);
    }
    addCreatorToEvent(event, hoopUpUser);

    debugPrint('Event created:\n'
        '  Date: $eventDate\n'
        '  Start time: $eventStartTime\n'
        '  End time: $eventEndTime\n'
        '  Number of participants: $numberOfParticipants\n'
        '  Gender: $selectedGender\n'
        '  Age group: $selectedAgeGroup\n'
        '  Skill level: $skillLevel\n'
        '  Event name: $eventName\n'
        '  Event description: $eventDescription\n'
        '  Court ID: $courtId\n'
        '  User ID: $userId');
  }
}

void addCreatorToEvent(Event event, HoopUpUser hoopUpUser) {
  // Add the user's ID to the event's list of users
  List<String> userIdsList = event.usersIds;
  List<String> newUserIdsList = List.from(userIdsList)..add(hoopUpUser.id);
  event.userIds = newUserIdsList;
  // Add the event ID to the user's list of events
  List<String> eventsList = hoopUpUser.events;
  List<String> newEventsList = List.from(eventsList)..add(event.id);
  hoopUpUser.events = newEventsList;
}

void removeUserFromEvent(
    String eventId,
    List<String> eventsList,
    List<String> userIdsList,
    HoopUpUserProvider hoopUpUserProvider,
    FirebaseProvider firebaseProvider) {
  // Remove the event ID from the user's list
  eventsList.remove(eventId);
  // Update the user's list of events in the database
  HoopUpUser? user = hoopUpUserProvider.user;
  user!.events = eventsList;
  // Remove the user's ID from the event's list of users
  userIdsList.removeWhere((index) => index == hoopUpUserProvider.user!.id);
  // Update the event's list of users in the database
  firebaseProvider.setFirebaseDataList('events/$eventId/userIds', userIdsList);
}

void addUserToEvent(
    String eventId,
    List<String> eventsList,
    List<String> userIdsList,
    HoopUpUserProvider hoopUpUserProvider,
    FirebaseProvider firebaseProvider) {
  if (eventsList.contains(eventId)) {
    debugPrint("User is already in this event");
    return;
  }
  // Add the new event ID to the user's list
  List<String> newEventsList = List.from(eventsList)..add(eventId);
  // Update the user's list of events in the database
  HoopUpUser? user = hoopUpUserProvider.user;
  user!.events = newEventsList;
  // Add the user's ID to the event's list of users
  List<String> newUserIdsList = List.from(userIdsList)
    ..add(hoopUpUserProvider.user!.id);
  // Update the event's list of users in the database
  firebaseProvider.setFirebaseDataList(
      'events/$eventId/userIds', newUserIdsList);
}

Future<void> removeOldEvents(
    {required FirebaseProvider firebaseProvider,
    required HoopUpUserProvider hoopUpUserProvider}) async {
  List<Event> eventsList = await firebaseProvider.getAllEventsFromFirebase();
  for (final event in eventsList) {
    if (event.time.endTime.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      firebaseProvider.removeFirebaseData('events/${event.id}');
      debugPrint('Event ${event.id} removed because it has ended');
    }
  }
  removeOldEventsFromUser(
      eventsList: eventsList, hoopUpUserProvider: hoopUpUserProvider);
}

void removeOldEventsFromUser(
    {required List<Event> eventsList,
    required HoopUpUserProvider hoopUpUserProvider}) async {
  HoopUpUser hoopUpUser = hoopUpUserProvider.user!;
  List<String> validEventIds = [];
  for (final eventId in hoopUpUser.events) {
    if (eventsList.any((event) => event.id == eventId)) {
      validEventIds.add(eventId);
    } else {
      debugPrint(
          "Event $eventId removed from user ${hoopUpUser.username} because "
          "it no longer exists");
    }
  }
  hoopUpUser.events = validEventIds;
}
