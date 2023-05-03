import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../classes/court.dart';

class CourtPage extends StatelessWidget {
  final Court court;

  const CourtPage({Key? key, required this.court}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(court.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display court information here
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      court.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.28,
                    width: double.infinity,
                    margin: const EdgeInsets.all(1.0),
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
                      child: Image.network(
                        court.imageLink,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Court type: ${court.courtType}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    court.address.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Display court location on a map
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
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
                    target: court.position,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(court.courtId),
                      position: court.position,
                      infoWindow: InfoWindow(
                        title: court.name,
                        snippet: court.address.toString(),
                      ),
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
