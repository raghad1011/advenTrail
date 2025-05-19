import 'package:adver_trail/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/bottomBar/map_screen.dart';
import '../Screens/bottomBar/setting_screen.dart';
import '../Screens/bottomBar/user_trip_history.dart';
import 'custom_scaffold.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LocationPage(),
    UserTripHistoryPage(userId: FirebaseAuth.instance.currentUser!.uid),
    const SettingScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      index: _selectedIndex,
      body: _pages[_selectedIndex],
      onTabTapped: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
