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
                    child: Image.asset('assets/images/talal.jpg', fit: BoxFit.cover),
                  ),

                  Positioned(
                    top: 90,
                    left: 120,
                    child: Image.asset('assets/images/Group 4.png', width: 130, height: 130),
                  ),
                  const Positioned(
                    top: 215,
                    left: 115,
                    child:Text(
                      'AdvenTrail',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(
                            0xff573f2b),
                      ),
                    ),),

                ],
              ),


            )));


  }}



// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'onboardingscreen1.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   SplashScreenState createState() => SplashScreenState();
// }
//
// class SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     handleDynamicLink();
//     // After 5 seconds, navigate to OnboardingScreen1
//
//   Future.delayed(const Duration(seconds: 5), () {
//   if (mounted) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) =>const OnboardingScreen1()),
//     );
//   }
// });
//   }
//   Future<void> handleDynamicLink() async {
//     final PendingDynamicLinkData? data =
//     await FirebaseDynamicLinks.instance.getInitialLink();
//
//     if (data?.link != null) {
//       final Uri deepLink = data!.link;
//       print('Received deep link: ${deepLink.toString()}');
//
//       // تحقق من الرابط الديناميكي
//       if (deepLink.path == '/forgot_password') {
//         // توجيه المستخدم إلى صفحة تغيير كلمة المرور
//         Navigator.pushReplacementNamed(context, '/forgot_password');
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//            body: Center(
//           child: Stack(
//             children: [
//
//               Positioned.fill(
//                 child: Image.asset('assets/images/talal.jpg', fit: BoxFit.cover),
//               ),
//
//               Positioned(
//                 top: 80,
//                 left: 190,
//                 child: Image.asset('assets/images/Group 4.png', width: 180, height: 180),
//               ),
//               const Positioned(
//                 top: 250,
//                 left: 225,
//                 child:Text(
//                   'AdvenTrail',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(
// 0xff573f2b),
//                   ),
//                 ),),
//
//             ],
//           ),
//
//
//         )));
//
//
//   }}
