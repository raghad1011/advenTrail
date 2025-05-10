import 'package:adver_trail/Screens/pageview.dart';
import 'package:adver_trail/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}
var cureentAddress = AddressModel();
void permission()async{

  PermissionStatus permissionStatus = await Permission.location.status;
  if (permissionStatus != PermissionStatus.granted) {
    await Permission.location.request();
  }
  if (permissionStatus.isGranted) {
    Position position = await Geolocator.getCurrentPosition();
    cureentAddress = AddressModel(
        latitude: position.latitude, longitude: position.longitude);
  }
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
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    permission();
    return  Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child:
                    Image.asset('assets/images/admin_bg.jpeg', fit: BoxFit.cover),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            ));
  }
}