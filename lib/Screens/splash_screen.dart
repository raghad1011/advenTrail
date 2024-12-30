import 'package:flutter/material.dart';
import 'onboardingscreen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to OnboardingScreen1
  
  Future.delayed(const Duration(seconds: 3), () {
  if (mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>const OnboardingScreen1()),
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
                child: Image.asset('assets/images/talal.jpg', fit: BoxFit.cover),
              ),

              Positioned(
                top: 80,
                left: 190,
                child: Image.asset('assets/images/Group 4.png', width: 180, height: 180),
              ),
              const Positioned(
                top: 250,
                left: 225,
                child:Text(
                  'AdvenTrail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(
0xff573f2b),
                  ),
                ),),
              
            ],
          ),
         
          
        )));
    
    
  }}
