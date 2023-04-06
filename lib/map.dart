import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref("/loc");

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  String _nameOfEvent = "";

  String _descriptionOfEvent = "";

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(59.334591, 18.063240),
    zoom: 12.5,
  );

  Marker _locationOfEvent = Marker(
    markerId: const MarkerId('empty'),
    position: _initialCameraPosition.target,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_locationOfEvent.markerId.value != "empty") _locationOfEvent,
        },
        onLongPress: _addMarker,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
                CameraPosition(target: _locationOfEvent.position, zoom: 15.0))),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _addMarker(LatLng pos) async {
    await _showInputBox(context);
    setState(() {
      _locationOfEvent = Marker(
        markerId: const MarkerId('origin'),
        infoWindow:
            InfoWindow(title: _nameOfEvent, snippet: _descriptionOfEvent),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
    await ref.set({
      "hjshda": pos.toString(),
    });
  }

  Future<void> _showInputBox(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter the name of the event...',
                ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter a description of the event...',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                // Do something with the user's input
                _nameOfEvent = nameController.text;
                _descriptionOfEvent = descriptionController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
