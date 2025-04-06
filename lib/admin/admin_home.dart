import 'package:adver_trail/admin/manage_trips_screen.dart';
import 'package:adver_trail/admin/manage_users_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Admin Sections Layout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAdminSection(Icons.person, "Manage Users", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageUsersScreen(),
                          ),
                        );
                      }),
                      SizedBox(width: 20),
                      _buildAdminSection(
                          Icons.manage_accounts, "Manage Trips", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageTripsScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAdminSection(Icons.book, "Booking", () {}),
                      SizedBox(width: 20),
                      _buildAdminSection(Icons.manage_history, "status", () {}),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each admin section widget
  Widget _buildAdminSection(IconData icon, String label, Function() onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.brown.shade200,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.black,
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
