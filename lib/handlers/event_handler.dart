import 'package:my_app/providers/hoopup_user_provider.dart';
import '../classes/hoopup_user.dart';
import 'firebase_handler.dart';

removeUserFromEvent(String eventId, List<String> eventsList, String userId,
    List<String> userIdsList, HoopUpUserProvider hoopUpUserProvider) {
  // Remove the event ID from the user's list
  eventsList.remove(eventId);
  // Update the user's list of events in the database
  HoopUpUser? user = hoopUpUserProvider.user;
  user!.events = eventsList;

  // Remove the user's ID from the event's list of users
  userIdsList.remove(userId);

  // Update the event's list of users in the database
  setFirebaseDataList('events/$eventId/userIds', userIdsList);
}

addUserToEvent(String eventId, List<String> eventsList, String userId,
    List<String> userIdsList, HoopUpUserProvider hoopUpUserProvider) {
  // Add the new event ID to the user's list
  List<String> newEventsList = List.from(eventsList)..add(eventId);

  // Update the user's list of events in the database
  HoopUpUser? user = hoopUpUserProvider.user;
  user!.events = newEventsList;

  // Add the user's ID to the event's list of users
  List<String> newUserIdsList = List.from(userIdsList)..add(userId);
  // Update the event's list of users in the database
  setFirebaseDataList('events/$eventId/userIds', newUserIdsList);
}
