import 'package:adver_trail/Screens/home_screen.dart';
import 'package:adver_trail/bottomBar/location_screen.dart';
import 'package:adver_trail/bottomBar/profile_screen.dart';
import 'package:flutter/material.dart';



class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = [
    const HomePage(), // محتوى الهوم فقط (بدون Scaffold)
    const LocationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 214, 202, 191),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 32,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on,size: 32), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.person,size: 32), label: 'Profile'),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../Screens/home_screen.dart';
// import '../bottomBar/game_screen.dart';
// import '../bottomBar/location_screen.dart';
// import '../bottomBar/save_screen.dart';
// import '../bottomBar/notification.dart';
//
// class  CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({super.key});
//
//   @override
//   MainAppState createState() => MainAppState();
// }
//
// class MainAppState extends State< CustomBottomNavBar> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomePage(),
//     const SavePage(),
//     const NotificationPage(),
//     const LocationPage(),
//     const GamePage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.brown[100],
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.brown,
//         unselectedItemColor: Colors.white,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.save),
//             label: 'Save',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notification',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.location_on),
//             label: 'Location',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorite',
//           ),
//         ],
//       ),
//     );
//   }
// }
