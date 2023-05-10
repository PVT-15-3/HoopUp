import 'package:flutter/material.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../classes/court.dart';
import '../classes/event.dart';
import '../handlers/share_event_handler.dart';
import '../providers/courts_provider.dart';
import '../handlers/event_handler.dart';
import '../providers/firebase_provider.dart';
import '../widgets/toaster.dart';

class EventPage extends StatefulWidget {
  final Event event;
  final List<Court> _courts = CourtProvider().courts;
  final bool hasUserJoined;

  EventPage({Key? key, required this.event, required this.hasUserJoined})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late String _creatorName = '';
  late int _numberOfPlayersInEvent = 0;
  late final FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    _firebaseProvider = context.read<FirebaseProvider>();
    super.initState();
    _getCreatorName();
    loadAmountOfUsersFirebase();
  }

  Court? _getCourt(String id) {
    for (Court court in widget._courts) {
      if (court.courtId == id) {
        return court;
      }
    }
    return null;
  }

  void _getCreatorName() async {
    FirebaseProvider firebaseProvider = FirebaseProvider();
    Map userMap = await firebaseProvider.getMapFromFirebase(
        "users", widget.event.creatorId);
    String name = userMap['username'];
    setState(() {
      _creatorName = name;
    });
  }

  loadAmountOfUsersFirebase() async {
    Map eventMap = await _firebaseProvider.getMapFromFirebase("events", widget.event.id);
    List<String> userIdsList = List.from(eventMap['userIds'] ?? []);
    _numberOfPlayersInEvent = userIdsList.length;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Court courtOfTheEvent = _getCourt(widget.event.courtId)!;
    final bool hasUserJoined = widget.hasUserJoined;
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
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  courtOfTheEvent.imageLink,
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
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Game at\n${widget.event.name}',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            courtOfTheEvent.address.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(children: [
                                const Icon(
                                  Icons.person,
                                  color: Styles.textColorMyBookings,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  _creatorName,
                                  style: const TextStyle(
                                    fontSize: Styles.fontSizeMedium,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: Styles.fontForNameFont,
                                    color: Styles.textColorMyBookings,
                                  ),
                                ),
                              ]),
                              const Spacer(),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                      '$_numberOfPlayersInEvent/${widget.event.playerAmount.toString()}')
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Hey!\nI plan to start a game at ${courtOfTheEvent.name} tomorrow the ${widget.event.time.getFormattedDate()} at the time ${widget.event.time.getFormattedStartAndEndTime()}.\n'
                            '\nAnyone with the skill level ${widget.event.skillLevel} is welcome!',
                            style: const TextStyle(
                              fontSize: Styles.fontSizeMedium,
                              fontWeight: FontWeight.normal,
                              fontFamily: Styles.subHeaderFont,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ShareEventHandler.shareEvent(
                                  widget.event, courtOfTheEvent);
                            },
                            child: const Icon(Icons.share),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            hasUserJoined
                ? const SizedBox.shrink()
                : Center(
                    child: TextButton(
                      onPressed: () async {
                        await addUserToThisEvent(context);

                        // Navigate back to the home page and reset the navigation stack
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/bottom_nav_bar',
                          (route) =>
                              false, // Remove all routes on top of the home page
                        );
                        // Call a method on the ChangeNotifier to trigger a state update
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

  addUserToThisEvent(BuildContext context) async {
    FirebaseProvider firebaseProvider = context.read<FirebaseProvider>();
    Map eventMap =
        await firebaseProvider.getMapFromFirebase("events", widget.event.id);
    List<String> userIdsList = List.from(eventMap['userIds'] ?? []);
    HoopUpUserProvider hoopUpUserProvider =
        Provider.of<HoopUpUserProvider>(context, listen: false);

    addUserToEvent(widget.event.id, hoopUpUserProvider.user!.events,
        userIdsList, hoopUpUserProvider, firebaseProvider);
    showCustomToast(
        "You have joined ${widget.event.name}", Icons.schedule, context);
  }
}
