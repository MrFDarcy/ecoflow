import 'package:ecoflow_v3/screens/action_screen.dart';
import 'package:ecoflow_v3/screens/home_screen.dart';
import 'package:ecoflow_v3/screens/metrics_screen.dart';
import 'package:ecoflow_v3/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/resources_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const ActionScreen(),
    const ResourcesScreen(),
    const MetricsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: NavigationBar(
          animationDuration: const Duration(milliseconds: 500),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb),
              label: 'Actions',
            ),
            NavigationDestination(
              icon: Icon(Icons.book),
              label: 'Resources',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics),
              label: 'Metrics',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
