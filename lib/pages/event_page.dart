import 'package:flutter/material.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../classes/court.dart';
import '../classes/event.dart';
import '../providers/courts_provider.dart';
import '../handlers/event_handler.dart';
import '../providers/firebase_provider.dart';
import '../widgets/toaster.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final List<Court> _courts = CourtProvider().courts;

  EventPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Court? courtOfTheEvent = getCourt(event.courtId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
              height: MediaQuery.of(context).size.height * 0.28,
              width: double.infinity,
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  'https://stockholmbasket.se/wp-content/uploads/2020/03/Kvarnholmen.jpg',
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Display event information here
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Styles.primaryColor,
                    ),
                  )),
                  const SizedBox(height: 8.0),
                  const Center(
                      child: Text(
                    'Adress goes here......',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  )),
                  const SizedBox(height: 4.0),
                  const SizedBox(height: 8.0),
                  Text(
                    'Court type: Court Type goes here',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date and time: ${event.time.getFormattedTimeAndDate()}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            Center(
              child: TextButton(
                onPressed: () async {
                  FirebaseProvider firebaseProvider =
                      context.read<FirebaseProvider>();
                  Map eventMap = await firebaseProvider.getMapFromFirebase(
                      "events", event.id);
                  List<String> userIdsList =
                      List.from(eventMap['userIds'] ?? []);
                  HoopUpUserProvider hoopUpUserProvider =
                      Provider.of<HoopUpUserProvider>(context, listen: false);

                  addUserToEvent(event.id, hoopUpUserProvider.user!.events,
                      userIdsList, hoopUpUserProvider, firebaseProvider);
                  showCustomToast(
                      "You have joined ${event.name}", Icons.schedule, context);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(98, 40),
                  backgroundColor: Styles.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'JOIN GAME',
                  style: TextStyle(
                    fontFamily: Styles.headerFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Court? getCourt(String id) {
    for (Court court in _courts) {
      if (court.courtId == id) {
        return court;
      }
    }
    return null;
  }
}
