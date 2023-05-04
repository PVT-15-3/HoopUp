import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/pages/court_page.dart';
import 'package:provider/provider.dart';

import '../classes/address.dart';
import '../classes/court.dart';
import '../providers/firebase_provider.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("/loc");

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _googleMapController;
  late final FirebaseProvider firebaseProvider;

  @override
  void initState() {
    super.initState();
    firebaseProvider = context.read<FirebaseProvider>();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
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
      firebaseProvider: firebaseProvider,
    ),
    Court(
        position: const LatLng(59.31414212184781, 18.193681711645432),
        name: 'Ektorps Streetcourt',
        imageLink:
            'https://stockholmbasket.se/wp-content/uploads/2022/06/Ektorp-streetcourt.jpg',
        courtType: 'PVC tiles',
        address: Address('Edinsvägen 4', 'Nacka', 13145, 59.31414212184781,
            18.193681711645432)),
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
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: _courtMarkers
            .map(
              (court) => Marker(
                markerId: MarkerId(court.courtId),
                position: court.position,
                onTap: () {
                  setState(() {
                    court.isSelected = !court.isSelected;
                  });
                },
                infoWindow: InfoWindow(
                  title: court.name,
                  snippet: court.address.toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourtPage(court: court),
                      ),
                    );
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            )
            .toSet(),
      ),
    );
  }
}
