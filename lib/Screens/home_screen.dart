import 'package:flutter/material.dart';
import '../component/category_scroll.dart';
import '../component/for_you_scroll.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات الرحلات
    final List<Map<String, dynamic>> trips = [
      {
        'images': ['assets/images/enaba1.jpg', 'assets/images/enaba2.jpg'],
        'title': "Ma'in Hot Springs",
        'price': '28 JD',
        'level': 'Easy',
        'distance':'10',
        'accessibility': 'Family Friendly',
        'details': 'This is Wadi al-Sham forest.',
        'city': 'Amman',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'King Talal Dam',
        'price': '25 JD',
        'level': 'Medium',
        'distance':'8 km',
        'accessibility': ' Friendly',
        'details': 'This is King Talal Dam.',
        'city': 'Aqaba',
        'latitude': 30.3285,
        'longitude': 35.4444
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Wadi al-Hasa',
        'price': '30 JD',
        'level': 'Medium',
        'distance':'10 km',
        'details': 'This is Wadi al-Hasa.',
        'city': 'Aqaba',
      'latitude': 32.2800,
      'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Wadi Al-Karak',
        'price': '40 JD',
        'level': 'Medium',
        'details': 'This is the Dead Sea.',
        'city': 'Irbid',
      'latitude': 32.2800,
      'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Enabh Forests',
        'price': '30 JD',
        'level': 'Medium',
        'details': 'This is Petra.',
        'city': 'aqaba',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Wadi Alsham',
        'price': '28 JD',
        'level': 'Medium',
        'details': 'This is Petra.',
        'city': 'aqaba',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Um Qais',
        'price': '25 JD',
        'level': 'Medium',
        'details': 'This is Petra.',
        'city': 'aqaba',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Wadi Mukhiris',
        'price': '30 JD',
        'level': 'Medium',
        'details': 'This is Petra.',
        'city': 'aqaba',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
      {
        'images': ['assets/images/talal.jpg'],
        'title': 'Wadi Rum camping',
        'price': '30 JD',
        'level': 'Medium',
        'details': 'This is Petra.',
        'city': 'aqaba',
        'latitude': 32.2800,
        'longitude': 35.8903
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        backgroundColor: const Color(0xffE6E6E6),
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, '/setting');
                    },
                    child: const Icon(Icons.search, color: Colors.black),
                  ),
                  hintText: 'Find your next adventure...',
                  filled: true,
                  fillColor: const Color(0xffD1C4B9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xff361C0B),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Image.asset('assets/images/Frame 40.png'),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: CategoryScroll(),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const SizedBox(width: 15),
              const Text(
                'Trips For You',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.filter_alt,
                  color: Colors.black,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/filter');
                },
              ),
            ],
          ),
          Expanded(
            child: ForYouScroll(
              trips: trips, // تمرير قائمة الرحلات
            ),
          ),
        ],
      ),
    );
  }
}
