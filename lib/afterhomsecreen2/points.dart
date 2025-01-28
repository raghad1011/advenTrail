import 'package:flutter/material.dart';

class PointsGiftsPage extends StatelessWidget {
  const PointsGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Points & Gifts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff361C0B),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner with Gift Image
          Padding(
            padding: const EdgeInsets.only(left: 16.0,top: 8),
            child: Container(
              width: 360,height: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:  const Color.fromARGB(255, 132, 117, 106),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 9,),
                  Image.asset('assets/images/gift.png',
                      height: 40, width: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: 'Every 25 points ',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18, color: Color(0xff573F2B))),
                          TextSpan(
                              text: '10% ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
                          TextSpan(
                              text: 'discount',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18, color: Color(0xff573F2B))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Points Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _buildPointCard('assets/images/image 6.png',
                      'Volunteer Points', '10 points'),
                  _buildPointCard('assets/images/hiking.png',
                      'Hard Trip Points', '6 points'),
                  _buildPointCard('assets/images/mountaineer.png',
                      'Moderate Trip Points', '4 points'),
                  _buildPointCard('assets/images/image 32.png',
                      'Easy Trip Points', '2 points'),
                ],
              ),
            ),
          ),
          //const SizedBox(height: 0.9,),
          const Divider(thickness: 1, color: Colors.black26),

          // Current Points Section
          const Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.0,vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You still do not have a point',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff361C0B),
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to Build Each Card
  Widget _buildPointCard(String imagePath, String title, String points) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xffD1C4B9), //
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: 60,
                width: 60,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}