import 'package:flutter/material.dart';
import 'package:my_app/classes/event.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/classes/time.dart';
import 'package:uuid/uuid.dart';

class EventHandler {
  void createEvent({
    required DateTime eventDate,
    required TimeOfDay eventStartTime,
    required TimeOfDay eventEndTime,
    required int numberOfParticipants,
    required String selectedGender,
    required String selectedAgeGroup,
    required int skillLevel,
    required String eventName,
    required String eventDescription,
    required String courtId,
    required String? userId,
    required HoopUpUser? hoopUpUser,
  }) {
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
    );
    event.addEventToDatabase();

    print('Event created:');
    print('  Date: $eventDate');
    print('  Start time: $eventStartTime');
    print('  End time: $eventEndTime');
    print('  Number of participants: $numberOfParticipants');
    print('  Gender: $selectedGender');
    print('  Age group: $selectedAgeGroup');
    print('  Skill level: $skillLevel');
    print('  Event name: $eventName');
    print('  Event description: $eventDescription');
    print('  Court ID: $courtId');
    print('  User ID: $userId');
  }
}
