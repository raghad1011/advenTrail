import 'dart:developer';

import 'package:adver_trail/Screens/home_screen.dart';
import 'package:adver_trail/Screens/pageview.dart';
import 'package:adver_trail/model/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

var cureentAddress = AddressModel();
void permission() async {
  PermissionStatus permissionStatus = await Permission.location.status;

  // 1. إذا لم يكن مفعّلًا، اطلب الإذن
  if (!permissionStatus.isGranted) {
    permissionStatus =
        await Permission.location.request(); // ← هنا نعيد القراءة
  }

  // 2. الآن تحقق من الحالة بعد الطلب
  if (permissionStatus.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    cureentAddress = AddressModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    log('${position.latitude}');
    log('${position.longitude}');
  } else {
    print("Location permission not granted");
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to OnboardingScreen1

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingPageView()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    permission();
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
