import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import '../classes/address.dart';
import '../classes/court.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'court_page.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("/loc");

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  @override
  void dispose() {
    _googleMapController.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }

  final List<Court> _courtMarkers = [
    Court(
      position: const LatLng(59.41539988194249, 18.045802457670916),
      name: 'Utomhusplanen Danderyd',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/IMG_3023-1.jpg',
      courtType: 'PVC tiles',
      address: Address(
        'Rinkebyvägen 4',
        'Danderyd',
        18236,
        59.41539988194249,
        18.045802457670916,
      ),
      numberOfHoops: 6,
    ),

    Court(
      position: const LatLng(59.31414212184781, 18.193681711645432),
      name: 'Ektorps Streetcourt',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/Ektorp-streetcourt.jpg',
      courtType: 'PVC tiles',
      address: Address('Edinsvägen 4', 'Nacka', 13145, 59.31414212184781,
          18.193681711645432),
      numberOfHoops: 6,
    ),

    Court(
      position: const LatLng(59.31182915015506, 18.074395203696394),
      name: 'Åsö - Södermalm',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/Aso_9.jpg',
      courtType: 'Asfalt',
      address: Address(
        'Blekingegatan 55',
        'Stockholm',
        11894,
        59.31182915015506,
        18.074395203696394,
      ),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.30782448316834, 17.994079119038222),
      name: 'Aspudden IP',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Aspudden-1-1200-1024x683-1.jpg',
      courtType: 'Synthetic rubber',
      address: Address('Hövdingsgatan 20', 'Hägersten', 12652,
          59.30782448316834, 17.994079119038222),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.29402145383548, 17.932262457670912),
      name: 'Parkleken Ängen - Bredäng',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Bred%C3%A4ng-1-1200-1024x683-1.jpg',
      courtType: 'Synthetic rubber',
      address: Address(
        'Bredängsvägen 22',
        'Skärholmen',
        12732,
        59.29402145383548,
        17.932262457670912,
      ),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.39710830523342, 17.90629260229956),
      name: 'Elinsborgs Basketplan - Tensta',
      imageLink:
          'https://www.courtsoftheworld.com/sweden/spanga/elinsborgs-basketplan/',
      courtType: 'Synthetic rubber',
      address: Address('Åvingegränd 29', 'Spånga', 16368, 59.39710830523342,
          17.90629260229956),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.21683912857965, 18.149234026943972),
      name: 'Skogåsskolan 3v3',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Skog%C3%A5s-1-1200-1024x683-1.jpg',
      courtType: 'PVC tiles',
      address: Address(
          'Lötbacken', 'SKogås', 14230, 59.21683912857965, 18.149234026943972),
      numberOfHoops: 1,
    ),

    Court(
      position: const LatLng(59.51779053942923, 17.640217411044326),
      name: 'Stjärnparken - Bro',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/rabyplanen.jpg',
      courtType: 'PVC tiles',
      address: Address('Idrottsstigen 15', 'Bro', 19731, 59.51779053942923,
          17.640217411044326),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.254592810710456, 18.031293796423572),
      name: 'Rågdalen - Rågsved',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/Ragsved.jpeg',
      courtType: 'Asfalt',
      address: Address('Bjursätragatan 50-52', 'Bandhagen', 12464,
          59.254592810710456, 18.031293796423572),
      numberOfHoops: 2,
    ),

    
    Court(
      position: const LatLng(59.37829473768301, 17.93254852514142),
      name: 'Rosa pantern - Rågsved',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Rissne-IP-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Mässvägen 1', 'Sundbyberg', 17459,
          59.37829473768301, 17.93254852514142),
      numberOfHoops: 4,
    ),

    
    Court(
      position: const LatLng(59.254592810710456, 18.031293796423572),
      name: 'Rågdalen - Rågsved',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/Ragsved.jpeg',
      courtType: 'Asfalt',
      address: Address('Bjursätragatan 50-52', 'Bandhagen', 12464,
          59.254592810710456, 18.031293796423572),
      numberOfHoops: 2,
    ),
    // Add more court markers here
  ];

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(59.334591, 18.063240),
    zoom: 10.3,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
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
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: Set<Marker>.of(
              _courtMarkers.map(
                (court) => Marker(
                  markerId: MarkerId(court.courtId),
                  position: court.position,
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourtPage(court: court),
                            ),
                          );
                        },
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                court.address.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
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
                                          color: Colors.white,
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
            height: 150,
            width: 225,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
