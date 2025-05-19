import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/bottomBar/map_screen.dart';
import '../Screens/bottomBar/setting_screen.dart';
import '../Screens/bottomBar/user_trip_history.dart';
import '../Screens/home_screen.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final int index;
  final Function(int)? onTabTapped;

  CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    required this.index,
     this.onTabTapped,
  });

  final List<Widget> pages = [
    HomePage(),
    LocationPage(),
    UserTripHistoryPage(userId: FirebaseAuth.instance.currentUser!.uid),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Color.fromARGB(255, 54, 36, 32),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '',),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),

        ],
        onTap: onTabTapped,
      ),
    );
  }
}
