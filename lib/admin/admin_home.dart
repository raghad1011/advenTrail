import 'package:adver_trail/admin/manage_trips_screen.dart';
import 'package:adver_trail/admin/manage_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Screens/login.dart';
import 'admin_rating_screen.dart';
import 'manage_bookings_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final Color olive = const Color(0xFF556B2F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D8B5D),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/admin_bg.jpeg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Admin Page",
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20,
                    children: [
                      _buildAdminCard(
                        icon: Icons.group,
                        label: "Manage Users",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ManageUsersScreen()),
                        ),
                      ),
                      _buildAdminCard(
                        icon: Icons.map,
                        label: "Manage Trips",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ManageTripsScreen()),
                        ),
                      ),
                      _buildAdminCard(
                        icon: Icons.calendar_today,
                        label: "Booking",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageBookingsScreen(),),
                        ),
                      ),
                      _buildAdminCard(
                        icon: Icons.rate_review_outlined,
                        label: "Ratings",
                        onTap: () => Get.to(()=>AdminRatingsScreen()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Get.offAll(()=>LoginScreen());},
              child: Row(
                children: [
                  Icon(Icons.logout,color: Colors.white),
                  Text('Logout',style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final olive = Color(0xFF354B0F);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: olive, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: olive),
            SizedBox(height: 15),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: olive,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}