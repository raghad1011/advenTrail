import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:const Color(0xffe6e6e6),
        body: Column(
          
          children: [
            Stack(
              children: [
                Positioned(
                  child: Image.asset('assets/images/imagebor2.png'),
                ),
                Positioned(
                  top: 80,
                  left: 150,
                  child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
                ),
              ],
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Text(
                  'Prepare For The Adventure..',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4f331e),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Get ready to make memories.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff4f331e),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Color((0xff4F331E)),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color((0xffe6e6e6)),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff4F331E),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Color((0xff4F331E)),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color((0xffe6e6e6)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/screen3');
              },
              child: const Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xff4F331E),
                  ),
                  Positioned(
                    left: 6,
                    top: 3,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 41,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                print("Skip");
              },
              child: const Stack(
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff4f331e),
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
