import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/joined_events_pages.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/pages/map.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../classes/address.dart';
import '../classes/court.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

 
  List<Court> get courtMarkers => _courtMarkers;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}
 final List<Court> _courtMarkers = [];

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

@override
  void initState() {
    super.initState();
    loadCourts();
  }
  final List<Widget> _pages = [
    const HomePage(),
    const JoinedEventsPage(showJoinedEvents: true),
    const Map(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!HoopUpUser.isSignedIn()) {
      return LogInPage();
    } else {
      return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.view_list),
              title: const Text('Joined event'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.map),
              title: const Text('Map'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
          ],
        ),
      );
    }
  }
  loadCourts(){

    _courtMarkers.addAll([
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
      name: 'Parkleken Ängen',
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
      name: 'Elinsborgs Basketplan',
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
      name: 'Stjärnparken',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/rabyplanen.jpg',
      courtType: 'PVC tiles',
      address: Address('Idrottsstigen 15', 'Bro', 19731, 59.51779053942923,
          17.640217411044326),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.254592810710456, 18.031293796423572),
      name: 'Rågdalen',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2022/06/Ragsved.jpeg',
      courtType: 'Asfalt',
      address: Address('Bjursätragatan 50-52', 'Bandhagen', 12464,
          59.254592810710456, 18.031293796423572),
      numberOfHoops: 2,
    ),

    
    Court(
      position: const LatLng(59.37829473768301, 17.93254852514142),
      name: 'Rosa pantern',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Rissne-IP-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Mässvägen 1', 'Sundbyberg', 17459,
          59.37829473768301, 17.93254852514142),
      numberOfHoops: 4,
    ),

    
    Court(
      position: const LatLng(59.361336758932545, 17.880385460974416),
      name: 'Parkleken Ådalen',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-V%C3%A4llingby-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Ångermannagatan 107', 'Vällingby', 16264,
          59.361336758932545, 17.880385460974416),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.33223538532373, 18.03662024059145),
      name: 'Kronobergsparken',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Kronobergsparken-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Parkgatan 6', 'Stockholm', 11230,
          59.33223538532373, 18.03662024059145),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.3177720380705, 18.13782764395781),
      name: 'Kvarnholmen 3v3',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/Kvarnholmen.jpg',
           courtType: 'PVC tiles',
      address: Address('Mjölnarvägen 16', 'Nacka', 13131,
          59.3177720380705, 18.13782764395781),
      numberOfHoops: 1,
    ),

    Court(
      position: const LatLng(59.32994118662108, 18.032987047205225),
      name: 'Kungsholmen Gymnasium',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-Kungsholmen-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Hantverkargatan 67', 'Stockholm', 11238,
          59.32994118662108, 18.032987047205225),
      numberOfHoops: 2,
    ),
     Court(
      position: const LatLng(59.328892205905085, 18.02265152337728),
      name: 'Rålambshovsparken 2v2',
      imageLink:
          'https://stockholmbasket.se/wp-content/uploads/2020/03/3.-R%C3%A5lambshovsparken-1-1200-1024x683-1.jpg',
          courtType: 'Asfalt',
      address: Address('Marieberg', 'Stockholm', 11235,
         59.328892205905085, 18.02265152337728),
      numberOfHoops: 2,
    ),
    // Add more court markers here
  ]);
  }
}
