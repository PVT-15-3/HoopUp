import 'package:my_app/classes/message.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import '../classes/hoopup_user.dart';
import 'package:my_app/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/time.dart';
import 'package:uuid/uuid.dart';
import 'package:synchronized/synchronized.dart';

final FirebaseProvider firebaseProvider = FirebaseProvider();

class EventHandler {
  final Lock appLock = Lock();
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
      userPhotoUrl: hoopUpUser.photoUrl,
      userId: hoopUpUser.id,
      messageText: eventDescription,
      timeStamp: DateTime.now(),
    );
    await appLock.synchronized(() async {
      try {
        await event.addEventToDatabase();
        if (message.messageText.isNotEmpty) {
          await event.chat.addMessage(message);
        }
        addUserToEvent(event, hoopUpUser);
      } on Exception catch (e) {
        debugPrint('Error creating event: $e');
      }
    }, timeout: const Duration(seconds: 5));
  }
}

void removeUserFromEvent(String eventId, List<String> eventsList,
    List<String> userIdsList, HoopUpUserProvider hoopUpUserProvider) async {
  // Remove the event ID from the user's list
  eventsList.remove(eventId);
  // Update the user's list of events in the database
  hoopUpUserProvider.user!.events = eventsList;
  // Remove the user's ID from the event's list of users
  userIdsList.removeWhere((index) => index == hoopUpUserProvider.user!.id);
  // Update the event's list of users in the database
  await firebaseProvider.setFirebaseDataList(
      'events/$eventId/userIds', userIdsList);
}

Future<void> addUserToEvent(Event event, HoopUpUser user) async {
  // Update users list
  if (!event.userIds.contains(user.id)) {
    // Add the user's ID to the event's list of users
    event.userIds = List.from(event.userIds)..add(user.id);
  }
  if (!user.events.contains(event.id)) {
    // Add the event ID to the user's list of events
    user.events = List.from(user.events)..add(event.id);
  }
}

Future<void> removeOldEvents(
    {required HoopUpUserProvider hoopUpUserProvider}) async {
  List<Event> eventsList = await firebaseProvider.getAllEventsFromFirebase();
  for (final event in eventsList) {
    if (event.time.endTime.isBefore(DateTime.now())) {
      firebaseProvider.removeFirebaseData('events/${event.id}');
      debugPrint('Event ${event.id} removed because it has ended');
    }
  }
  removeOldEventsFromUser(
      eventsList: eventsList, hoopUpUserProvider: hoopUpUserProvider);
}

void removeOldEventsFromUser({
  required List<Event> eventsList,
  required HoopUpUserProvider hoopUpUserProvider,
}) {
  HoopUpUser hoopUpUser = hoopUpUserProvider.user!;

  List<String> validEventIds = List<String>.from(hoopUpUser.events);
  validEventIds.removeWhere(
      (eventId) => !eventsList.any((event) => event.id == eventId));

  List<String> removedEventIds =
      hoopUpUser.events.toSet().difference(validEventIds.toSet()).toList();
  for (final removedEventId in removedEventIds) {
    debugPrint(
        "Event $removedEventId removed from user ${hoopUpUser.username} because it no longer exists");
  }

  hoopUpUser.events = validEventIds;
}
