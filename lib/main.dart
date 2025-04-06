import 'package:adver_trail/CategoryHomeScreeen.dart/camping_page.dart';
import 'package:adver_trail/CategoryHomeScreeen.dart/cycling_page.dart';
import 'package:adver_trail/CategoryHomeScreeen.dart/volunteering_page.dart';
import 'package:adver_trail/CategoryHomeScreeen.dart/water_parks_page.dart';
import 'package:adver_trail/Screens/home_screen.dart';
import 'package:adver_trail/Screens/login.dart';
import 'package:adver_trail/Screens/forgot_password.dart';
import 'package:adver_trail/Screens/notification.dart';
import 'package:adver_trail/Screens/splash_screen.dart';
import 'package:adver_trail/Screens/signup.dart';
import 'package:adver_trail/Screens/verify.dart';
import 'package:adver_trail/admin/admin_home.dart';
import 'package:adver_trail/afterhomsecreen2/edit_profile.dart';
import 'package:adver_trail/afterhomsecreen2/filter.dart';
import 'package:adver_trail/afterhomsecreen2/points.dart';
import 'package:adver_trail/component/custom_bottom_nav_bar.dart';
import 'package:adver_trail/component/email_link.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CategoryHomeScreeen.dart/mountain_trails-page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: _onGenerateRoute,
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/adminHome': (context) => const AdminHomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
       // '/verify': (context) => const VerifyScreen(),
        '/volunteering': (context) => const VolunteeringPage(),
        '/bottomNav': (context) => const CustomBottomNavBar(),
        '/cycling': (context) => const CyclingPage(),
        '/mountain_trails': (context) => const MountainTrailsPage(),
        '/camping': (context) => const CampingPage(),
        '/water_parks': (context) => const WaterParksPage(),
        '/forgot_password': (context) => NewpasswordScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/notification': (context) => NotificationPage(),
        '/filter': (context) => FilterPage(),
        '/point': (context)=> PointsGiftsPage(),

      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/forgot_password') {
      return MaterialPageRoute(
        builder: (context) => const EmailLinkHandler(),
      );
    }
    return null;
  }
}



// import 'package:adver_trail/CategoryHomeScreeen.dart/camping_page.dart';
// import 'package:adver_trail/CategoryHomeScreeen.dart/cycling_page.dart';
// import 'package:adver_trail/CategoryHomeScreeen.dart/volunteering_page.dart';
// import 'package:adver_trail/CategoryHomeScreeen.dart/water_parks_page.dart';
// import 'package:adver_trail/Screens/home_screen.dart';
// import 'package:adver_trail/Screens/login.dart';
// import 'package:adver_trail/Screens/forgot_password.dart';
// import 'package:adver_trail/Screens/onboardingscreen2.dart';
// import 'package:adver_trail/Screens/onboardingscreen3.dart';
// import 'package:adver_trail/Screens/splash_screen.dart';
// import 'package:adver_trail/Screens/signup.dart';
// import 'package:adver_trail/Screens/verify.dart';
// import 'package:adver_trail/component/custom_bottom_nav_bar.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'CategoryHomeScreeen.dart/mountain_trails-page.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: "/",
//       routes: {
//         '/': (context) => const SplashScreen(),
//         '/screen2': (context) => const OnboardingScreen2(),
//         '/screen3': (context) => const OnboardingScreen3(),
//         '/home': (context) => const HomePage(),
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/verify': (context) => const VerifyScreen(),
//         '/volunteering': (context) => const VolunteeringPage(),
//         '/bottomNav': (context) => const CustomBottomNavBar(),
//         '/cycling': (context) => const CyclingPage(),
//         '/mountain_trails': (context) => const MountainTrailsPage(),
//         '/camping': (context) => const CampingPage(),
//         '/water_parks': (context) => const WaterParksPage(),
//         '/forgot_password': (context) =>  NewpasswordScreen(),
//       },
//     );
//   }
// }
