import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/joined_events_pages.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/pages/map.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../classes/court.dart';
import '../providers/courts_provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  List<Court> get courtMarkers => _courtMarkers;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

late List<Court> _courtMarkers;

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _courtMarkers = CourtProvider().courts;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const Map(),
    const JoinedEventsPage(showJoinedEvents: true),
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
          containerHeight: 60,
          iconSize: 30,
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
              icon: const Icon(Icons.pin_drop),
              title: const Text('Map'),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.sports_basketball),
              title: const Text('Joined event'),
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
}
