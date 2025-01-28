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
        'images': [
          'assets/images/talal2.JPG',
          'assets/images/talal4.JPG',
          'assets/images/talal1.JPG',
          'assets/images/talal5.JPG'
        ],
        'title': 'King Talal Dam',
        'price': '25 JD',
        'level': 'Easy',
        'category': 'Water Parks',
        'distance': '8 km',
        'accessibility': 'child-Friendly',
        'details':
            "Located in northern Jordan, King Talal Dam is a magnificent site surrounded by lush green landscapes.\n   The area features a blend of natural beauty and historical significance, offering an escape into serene views.\n   The trail around the dam offers a mix of open paths and shaded areas, ideal for walking and exploring. Visitors can enjoy the tranquil environment, with scenic spots perfect for rest and photography.\n   This trail is a testament to Jordan's rich natural heritage and is a must-visit for adventure enthusiasts.",
        'selectedDay': 'Sun',
        'city': 'Jerash ',
        'latitude': 32.1904,
        'longitude': 35.7983
      },
      {
        'images': [
          'assets/images/hasa (2).PNG',
          'assets/images/hasa (1).PNG',
          'assets/images/hasa (3).PNG',
          'assets/images/hasa (4).PNG'
        ],
        'title': 'Wadi al-Hasa',
        'price': '30 JD',
        'level': 'Moderate',
        'category': 'Water Parks',
        'distance': '10 km',
        'accessibility': 'child-Friendly',
        'details':
            "Situated in southern Jordan, Wadi Al-Hasa is a breathtaking canyon known for its lush vegetation, natural water springs, and stunning rock formations.\n   The trail offers a mix of shaded walks, water crossings, and open landscapes, making it perfect for hikers and adventurers.\n   Along the way, you'll encounter natural pools and a variety of flora and fauna unique to the region. Wadi Al-Hasa is a jewel of Jordan’s adventure tourism, promising an unforgettable experience.",
        'selectedDay': 'Mon',
        'city': 'Tafilah ',
        'latitude': 30.8372,
        'longitude': 35.6216
      },
      {
        'images': [
          'assets/images/enaba1.jpg',
          'assets/images/enaba2.jpg',
          'assets/images/enaba3.jpeg',
          'assets/images/enaba4.PNG'
        ],
        'title': 'Enabh Forests',
        'price': '30 JD',
        'level': 'Easy',
        'category': 'Mountain Trails',
        'distance': '10 km',
        'accessibility': 'child-Friendly',
        'details':
            '     located in northern Jordan. It is one of the dense forests full of oak, sycamore, oak, hawthorn and sycamore trees.\n\nThe trail features shaded walks throughout the trail, and the trail ends with a view called Iraq Al-Tabl, and Iraq means hills.\n\nThe walk is one-way and will take you to the rest area and the bus.The trail is very special, and it is one of the most important landmarks of adventure tourism in Jordan.',
        'selectedDay': 'Fri',
        'city': 'Ajloun ',
        'latitude': 32.2833,
        'longitude': 35.7500,
      },
      {
        'images': [
          'assets/images/rum (4).PNG',
          'assets/images/rum (5).PNG',
          'assets/images/rum (3).PNG',
          'assets/images/rum (1).PNG',
          'assets/images/rum (2).PNG',
        ],
        'title': 'Wadi Rum camping',
        'price': '35 JD',
        'level': 'hard',
        'details':
            'Located in central Jordan, Wadi Talal is a hidden gem that captivates visitors with its rugged beauty and serene atmosphere.\n   The trail is characterized by its winding paths, surrounded by cliffs and diverse vegetation. The area is ideal for those seeking an adventurous hike combined with the tranquility of nature.\n   The trail leads to stunning viewpoints, providing a perfect spot to relax and appreciate the majestic scenery. Wadi Talal is a prime destination for nature lovers and adventure seekers alike.',
        'city': 'Aqaba',
        'latitude': 29.5766,
        'longitude': 35.4195
      },
      {
        'images': [
          'assets/images/alsham (5).PNG',
          'assets/images/alsham (2).PNG',
          'assets/images/alsham (1).PNG',
          'assets/images/alsham (3).PNG'
        ],
        'title': 'Wadi Alsham',
        'price': '28 JD',
        'level': 'Hard',
        'details': 'This is Petra.',
        'city': "Ma'an",
        'latitude': 31.9500,
        'longitude': 35.9333
      },
      {
        'images': [
          'assets/images/karak (3).PNG',
          'assets/images/karak (1).PNG',
          'assets/images/karak (2).PNG',
          'assets/images/karak (4).PNG'
        ],
        'title': 'Wadi Al-Karak',
        'category': 'Mountain Trails',
        'price': '40 JD',
        'level': 'Hard',
        'details': 'This is the Dead Sea.',
        'city': 'Karak',
        'latitude': 31.1833,
        'longitude': 35.7000
      },
      {
        'images': [
          'assets/images/Ma (3).PNG',
          'assets/images/Ma (1).PNG',
          'assets/images/Ma (2).PNG',
          'assets/images/Ma (4).PNG',
          'assets/images/Ma (5).PNG'
        ],
        'title': "Ma'in Hot Spring",
        'price': '30 JD',
        'level': 'Easy',
        'details': 'This is Petra.',
        'city': 'Madaba',
        'latitude': 31.6100,
        'longitude': 35.6100
      },
      {
        'images': [
          'assets/images/qais (4).JPG',
          'assets/images/qais (1).JPG',
          'assets/images/qais (3).JPG',
          'assets/images/qais (2).JPG'
        ],
        'title': 'Um Qais',
        'price': '25 JD',
        'level': 'Moderate',
        'details': 'This is Petra.',
        'city': 'Irbid',
        'latitude': 32.6531,
        'longitude': 35.6846
      },
      {
        'images': ['assets/images/mukhiris.PNG', 'assets/images/mukhiris.JPG'],
        'title': 'Wadi Mukhiris',
        'price': '30 JD',
        'level': 'Moderate',
        'details': 'This is Petra.',
        'city': 'Dead Sea',
        'latitude': 31.7167,
        'longitude': 35.5500
      },
      {
        'images': ['assets/images/cycling (1).PNG', 'assets/images/cycling (2).PNG','assets/images/cycling (3).PNG'],
        'title': 'Cycling',
        'price': '15 JD',
        'level': 'Easy',
        'accessibility': 'wheelchair',
        'details': '',
        'city': 'Amman',
        'latitude': 31.9539,
        'longitude': 35.9106
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                Icons.notifications,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
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
            child: Stack(
              alignment: Alignment.center, // لمحاذاة الصورة الثانية في المنتصف
              children: [
                Image.asset(
                  'assets/images/Frame 40.png', // الصورة الأساسية
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50, // تعديل موضع الصورة الثانية
                  right: 40, // تعديل موضع الصورة الثانية
                  child: GestureDetector(
                    onTap: () {
                      // الانتقال إلى الصفحة الثانية عند الضغط على الصورة
                      Navigator.pushNamed(context, '/point');
                    },
                    child: Image.asset(
                      'assets/images/gift.png', // الصورة الجديدة (فوق الأساسية)
                      width: 30,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
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
