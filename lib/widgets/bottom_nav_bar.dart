import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/joined_events_pages.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/start_page.dart';
import 'package:my_app/pages/map_page.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:my_app/widgets/toaster.dart';
import '../app_styles.dart';
import '../classes/court.dart';
import '../providers/courts_provider.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  Set<Court> get courtMarkers => _courtMarkers;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

late Set<Court> _courtMarkers;

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _courtMarkers = CourtProvider().courts;
  }

  final List<Widget> _pages = [
    const HomePage(),
    MapPage(showSelectOption: false),
    const JoinedEventsPage(showJoinedEvents: true),
    const ProfilePage(),
  ];

  void onChangedPage(index) {
    setState(() {
      _currentIndex = index;
    });
    Toaster.clearToast();
  }

  @override
  Widget build(BuildContext context) {
    if (!HoopUpUser.isSignedIn()) {
      return StartPage();
    } else {
      return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavyBar(
          containerHeight: 60,
          iconSize: 30,
          selectedIndex: _currentIndex,
          onItemSelected: onChangedPage,
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: Styles.primaryColor,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.pin_drop),
              title: const Text('Map'),
              activeColor: Styles.primaryColor,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.sports_basketball),
              title: const Text('Bookings'),
              activeColor: Styles.primaryColor,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
              activeColor: Styles.primaryColor,
              inactiveColor: Colors.grey,
            ),
          ],
        ),
      );
    }
  }
}
