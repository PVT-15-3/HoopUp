import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/pages/chat_page.dart';
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
  final Set<Court> _courts = CourtProvider().courts;
  final bool hasUserJoined;

  EventPage({Key? key, required this.event, required this.hasUserJoined})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  BitmapDescriptor? customMarkerIcon;
  late String _creatorName = '';
  late int _numberOfPlayersInEvent = 0;
  late final FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    _firebaseProvider = context.read<FirebaseProvider>();
    super.initState();
    _getCreatorName();
    _loadCustomMarkerIcon();
    loadAmountOfUsersFirebase();
  }

  Future<void> _loadCustomMarkerIcon() async {
    final ByteData markerIconData = await rootBundle
        .load('assets/markerImage.png'); // URL to the marker icon
    final Uint8List markerIconBytes = markerIconData.buffer.asUint8List();
    customMarkerIcon = BitmapDescriptor.fromBytes(markerIconBytes);
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
    Map<dynamic, dynamic> userMap = await firebaseProvider.getMapFromFirebase(
        "users", widget.event.creatorId);
    String name = userMap['username'];
    setState(() {
      _creatorName = name;
    });
  }

  loadAmountOfUsersFirebase() async {
    Map eventMap =
        await _firebaseProvider.getMapFromFirebase("events", widget.event.id);
    List<String> userIdsList = List.from(eventMap['userIds'] ?? []);
    _numberOfPlayersInEvent = userIdsList.length;
    return true;
  }

  TextSpan _getSubtitleText() {
    final timeText = TextSpan(
      text: 'Time: ',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: Styles.subHeaderFont,
        color: Styles.discoverGametextColor,
        fontSize: Styles.fontSizeMedium,
      ),
      children: [
        TextSpan(
          text: widget.event.time.getFormattedStartAndEndTime(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );

    final dateText = TextSpan(
      text: '\nDate: ',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: Styles.subHeaderFont,
        color: Styles.discoverGametextColor,
        fontSize: Styles.fontSizeMedium,
      ),
      children: [
        TextSpan(
          text: widget.event.time.getFormattedDate(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );

    return TextSpan(
      children: [timeText, dateText],
    );
  }

  Icon getGenderIcon() {
    const double iconSize = 25.0;
    if (widget.event.genderGroup == 'Female') {
      return const Icon(
        Icons.female,
        color: Styles.primaryColor,
        size: iconSize,
      );
    }
    if (widget.event.genderGroup == 'Male') {
      return const Icon(
        Icons.male,
        color: Styles.primaryColor,
        size: iconSize,
      );
    }
    if (widget.event.genderGroup == 'All') {
      return const Icon(
        Icons.group,
        color: Styles.primaryColor,
        size: iconSize,
      );
    }
    return const Icon(
      Icons.transgender,
      color: Styles.primaryColor,
      size: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    Court courtOfTheEvent = _getCourt(widget.event.courtId)!;
    final bool hasUserJoined = widget.hasUserJoined;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                ShareEventHandler.shareEvent(widget.event, courtOfTheEvent);
              },
              child: const Icon(Icons.share),
            ),
          )
        ],
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
                            'Game at\n${courtOfTheEvent.name}',
                            style: const TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                                color: Styles.primaryColor,
                                fontFamily: Styles.subHeaderFont),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 0.0),
                          InkWell(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(17.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 8.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: courtOfTheEvent.position,
                                        zoom: 15,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId:
                                              MarkerId(courtOfTheEvent.courtId),
                                          position: courtOfTheEvent.position,
                                          icon: customMarkerIcon ??
                                              BitmapDescriptor.defaultMarker,
                                          infoWindow: InfoWindow(
                                            title: courtOfTheEvent.name,
                                            snippet: courtOfTheEvent.address
                                                .toString(),
                                          ),
                                        ),
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  courtOfTheEvent.address.toString(),
                                  style: const TextStyle(
                                    fontSize: Styles.fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Styles.headerFont,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.blueGrey,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(children: [
                                const Icon(
                                  Icons.person_pin,
                                  color: Styles.textColorMyBookings,
                                  size: 50,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  _creatorName,
                                  style: const TextStyle(
                                    fontSize: Styles.fontSizeMedium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Styles.fontForNameFont,
                                    color: Styles.textColorMyBookings,
                                  ),
                                ),
                              ]),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    '$_numberOfPlayersInEvent/${widget.event.playerAmount.toString()} players',
                                    style: const TextStyle(
                                      fontSize: Styles.fontSizeSmall,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Styles.subHeaderFont,
                                      color: Styles.textColorMyBookings,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Center(
                            child: Text.rich(
                              _getSubtitleText(),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Skill Level: ',
                                style: TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.textColor,
                                ),
                              ),
                              if (widget.event.skillLevel == 0)
                                const Text(
                                  'All',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Styles.fontSizeMedium,
                                    fontFamily: Styles.subHeaderFont,
                                    color: Styles.primaryColor,
                                  ),
                                )
                              else
                                Row(
                                  children: List.generate(
                                    widget.event.skillLevel,
                                    (index) => const Icon(
                                      Icons.star_purple500_sharp,
                                      color: Styles.primaryColor,
                                      size: 23,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 7.0, height: 12.0),
                          Row(
                            children: [
                              const Text(
                                'Gender: ',
                                style: TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.textColor,
                                ),
                              ),
                              widget.event.genderGroup == 'All'
                                  ? const Text(
                                      'All',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Styles.fontSizeMedium,
                                        fontFamily: Styles.subHeaderFont,
                                        color: Styles.primaryColor,
                                      ),
                                    )
                                  : getGenderIcon(),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const Text(
                                'Age: ',
                                style: TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.textColor,
                                ),
                              ),
                              Text(
                                widget.event.ageGroup,
                                style: const TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.primaryColor,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                    Icons.chat_bubble_outline_rounded),
                                color: Styles.primaryColor,
                                iconSize: 35,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        event: widget.event,
                                        court: courtOfTheEvent,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  hasUserJoined
                      ? const SizedBox.shrink()
                      : Center(
                          child: TextButton(
                            onPressed: () {
                              addUserToThisEvent(context).then((_) {
                                showCustomToast(
                                  "You have joined a game at ${courtOfTheEvent.name}",
                                  Icons.schedule,
                                  context,
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/bottom_nav_bar',
                                  (route) => false,
                                );
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Styles.primaryColor,
                              minimumSize: const Size(130, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: const Text(
                              'JOIN GAME',
                              style: TextStyle(
                                fontFamily: Styles.buttonFont,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addUserToThisEvent(BuildContext context) {
    FirebaseProvider firebaseProvider = context.read<FirebaseProvider>();
    return firebaseProvider
        .getMapFromFirebase("events", widget.event.id)
        .then((eventMap) {
      List<String> userIdsList = List.from(eventMap['userIds'] ?? []);
      HoopUpUserProvider hoopUpUserProvider =
          Provider.of<HoopUpUserProvider>(context, listen: false);

      addUserToEvent(
        widget.event.id,
        hoopUpUserProvider.user!.events,
        userIdsList,
        hoopUpUserProvider,
        firebaseProvider,
      );
    });
  }
}
