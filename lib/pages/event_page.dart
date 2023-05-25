import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/chat_page.dart';
import 'package:my_app/providers/hoopup_user_provider.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../app_styles.dart';
import '../classes/court.dart';
import '../classes/event.dart';
import '../classes/message.dart';
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
  String _creatorName = '';
  String _creatorPhotoUrl = '';
  int _numberOfPlayersInEvent = 0;
  late FirebaseProvider firebaseProvider;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcon();
    _loadInfo();
    firebaseProvider = context.read<FirebaseProvider>();
  }

  Future<void> _loadInfo() async {
    HoopUpUser user =
        await firebaseProvider.getUserFromFirebase(widget.event.creatorId);
    setState(() {
      _creatorName = user.username;
    });
    setState(() {
      _creatorPhotoUrl = user.photoUrl;
    });
    setState(() {
      _numberOfPlayersInEvent = widget.event.userIds.length;
    });
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
    final FirebaseProvider firebaseProvider = context.read<FirebaseProvider>();
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
                                  courtOfTheEvent.address
                                      .toStringOnTheSameLine(),
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
                              Row(
                                children: [
                                  if (_creatorPhotoUrl.isNotEmpty)
                                    CircleAvatar(
                                      backgroundImage: _creatorPhotoUrl != ""
                                          ? NetworkImage(_creatorPhotoUrl)
                                          : const AssetImage('assets/logo.png')
                                              as ImageProvider<Object>,
                                      radius: 25,
                                    )
                                  else
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
                                ],
                              ),
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
                          const SizedBox(
                            height: 12.0,
                          ),
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
                                '${widget.event.minimumAge} - ${widget.event.maximumAge}',
                                style: const TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Floor Type: ',
                                style: TextStyle(
                                  fontSize: Styles.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.textColor,
                                ),
                              ),
                              Text(
                                courtOfTheEvent.courtType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Styles.fontSizeMedium,
                                  fontFamily: Styles.subHeaderFont,
                                  color: Styles.primaryColor,
                                ),
                              ),
                              const Spacer(),
                              Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                    ),
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
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: StreamBuilder<List<Message>>(
                                      stream:
                                          firebaseProvider.getChatMessageStream(
                                              widget.event.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child:
                                                const CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          );
                                        } else {
                                          List<Message> messages =
                                              snapshot.data ?? [];
                                          int numberOfChatMessages =
                                              messages.length;

                                          return Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$numberOfChatMessages',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
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
                              if (_numberOfPlayersInEvent >=
                                  widget.event.playerAmount) {
                                showCustomToast("This event is full!",
                                    Icons.error, context);
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actionsPadding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 10.0,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 5),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: _getContetText(courtOfTheEvent),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Styles.textColor,
                                                  backgroundColor: Colors.white,
                                                  side: const BorderSide(
                                                      color: Styles.textColor),
                                                  minimumSize:
                                                      const Size(105, 39),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'No, Cancel',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          Styles.mainFont,
                                                      fontSize: Styles
                                                          .fontSizeSmallest,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Styles.primaryColor,
                                                  side: const BorderSide(
                                                      color: Styles.textColor),
                                                  minimumSize:
                                                      const Size(105, 39),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Yes, confirm',
                                                  style: TextStyle(
                                                    fontFamily: Styles.mainFont,
                                                    fontSize:
                                                        Styles.fontSizeSmallest,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  addUserToEvent(
                                                    widget.event,
                                                    Provider.of<HoopUpUserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user!,
                                                  ).then((_) {
                                                    showCustomToast(
                                                        "You have joined a game at ${courtOfTheEvent.name}",
                                                        Icons.schedule,
                                                        context);
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const BottomNavBar(
                                                                          currentIndex:
                                                                              2,
                                                                        )),
                                                            (route) => false);
                                                  }); // Close the dialog
                                                },
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
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

  TextSpan _getContetText(Court courtOfTheEvent) {
    final contetText = TextSpan(
      text: 'Do you want to join a game at',
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: Styles.subHeaderFont,
        color: Styles.textColor,
        fontSize: Styles.fontSizeSmall,
      ),
      children: [
        TextSpan(
          text:
              '\n${courtOfTheEvent.name}\n${widget.event.time.getFormattedTimeAndDate()}?',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: Styles.subHeaderFont,
            color: Styles.textColor,
            fontSize: Styles.fontSizeSmall,
          ),
        ),
      ],
    );
    return contetText;
  }
}
