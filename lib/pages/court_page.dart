import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/app_styles.dart';
import '../classes/court.dart';

class CourtPage extends StatelessWidget {
  final Court court;

  const CourtPage({Key? key, required this.court}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // Display court information here
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Center(
                      child: Text(court.name,
                          style: const TextStyle(
                            fontSize: Styles.fontSizeBig,
                            fontWeight: FontWeight.bold,
                            color: Styles.discoverGametextColor,
                            fontFamily: Styles.headerFont,
                          )),
                    ),
                  ),
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
                      child: Image.asset(
                        court.imageLink,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Card(
                    elevation: 0.0,
                    margin: const EdgeInsets.all(3),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                              Text(
                                'Flooring: ${court.courtType}',
                                style: const TextStyle(
                                  fontSize: Styles.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                  color: Styles.discoverGametextColor,
                                  fontFamily: Styles.subHeaderFont,
                                ),
                              ),
                             
                              const SizedBox(height: 4.0),
                              Text(
                                'Number of Hoops: ${court.numberOfHoops}',
                                style: const TextStyle(
                                  fontSize: Styles.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                  color: Styles.discoverGametextColor,
                                  fontFamily: Styles.subHeaderFont,
                                ),
                              ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Adress: ${court.address.toString()}',
                                style: const TextStyle(
                                  fontSize: Styles.fontSizeSmall,
                                  fontWeight: FontWeight.w600,
                                  color: Styles.discoverGametextColor,
                                  fontFamily: Styles.subHeaderFont,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0.0),
            // Display court location on a map
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
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
