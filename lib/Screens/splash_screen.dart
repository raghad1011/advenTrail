import 'package:adver_trail/Screens/pageview.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to OnboardingScreen1

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPageView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child:
                    Image.asset('assets/images/talal.jpg', fit: BoxFit.cover),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.2, // 20% from the top
                left: MediaQuery.of(context).size.width / 2 -
                    65, // center (130/2 = 65)
                child: Column(
                  children: [
                    Image.asset('assets/images/Group 4.png',
                        width: 130, height: 130),
                    const SizedBox(height: 5),
                    // spacing between logo and text
                    const Text(
                      'AdvenTrail',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff573f2b),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
