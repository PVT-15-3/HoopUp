import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/widgets/bottom_nav_bar.dart';
import '../app_styles.dart';
import '../classes/court.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'court_page.dart';
import 'package:flutter/services.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  BitmapDescriptor? customMarkerIcon;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    await _loadCustomMarkerIcon();
  }

  Future<void> _loadCustomMarkerIcon() async {
    final ByteData markerIconData = await rootBundle
        .load('assets/markerImage.png'); // URL to the marker icon
    final Uint8List markerIconBytes = markerIconData.buffer.asUint8List();
    customMarkerIcon = BitmapDescriptor.fromBytes(markerIconBytes);
  }

  final List<Court> _courtMarkers = const BottomNavBar().courtMarkers;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(59.349821, 17.952483),
    zoom: 9.7,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialization is complete, you can build your UI
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  GoogleMap(
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    markers: Set<Marker>.of(
                      _courtMarkers.map(
                        (court) => Marker(
                          markerId: MarkerId(court.courtId),
                          position: court.position,
                          icon: customMarkerIcon ??
                              BitmapDescriptor.defaultMarker,
                          onTap: () {
                            _customInfoWindowController.addInfoWindow!(
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CourtPage(court: court),
                                    ),
                                  );
                                },
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Styles.primaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.sports_basketball,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                              court.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     borderRadius: BorderRadius.circular(4),
                                    //   ),
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text(
                                    //     court.address.toString(),
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .titleMedium!
                                    //         .copyWith(
                                    //           color: Colors.black,
                                    //         ),
                                    //   ),
                                    // ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'More info',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          const Icon(
                                            Icons.info,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              court.position,
                            );
                          },
                        ),
                      ),
                    ),
                    initialCameraPosition: _initialCameraPosition,
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 100,
                    width: 220,
                    offset: 30,
                  ),
                ],
              ),
            );
          } else {
            // Show a loading indicator while waiting for initialization
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
