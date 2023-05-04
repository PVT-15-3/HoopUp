import 'package:flutter/material.dart';
import 'package:my_app/classes/hoopup_user.dart';
import 'package:my_app/pages/joined_events_pages.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/log_in_page.dart';
import 'package:my_app/pages/map.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    JoinedEventsPage(showJoinedEvents: true),
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
}
