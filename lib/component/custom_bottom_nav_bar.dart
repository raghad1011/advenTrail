import 'package:flutter/material.dart';
import '../Screens/home_screen.dart';
import '../bottomBar.dart/game_screen.dart';
import '../bottomBar.dart/location_screen.dart';
import '../bottomBar.dart/save_screen.dart';
import '../bottomBar.dart/notification.dart';

class  CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State< CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SavePage(),
    const NotificationPage(),
    const LocationPage(),
    const GamePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.brown[100],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.white, 
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
