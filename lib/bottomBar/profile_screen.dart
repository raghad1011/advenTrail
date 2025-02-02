import 'package:adver_trail/component/ProfileListItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
          onPressed: () {
            Navigator.pushNamed(context, '/bottomNav');
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xff361C0B),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                ProfileListItem(
                  icon: Icons.person_pin_rounded,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                ),
                ProfileListItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot_password');
                  },
                ),
                ProfileListItem(
                  icon: Icons.location_on,
                  title: 'Location',
                  onTap: () {},
                ),
                ProfileListItem(
                  icon: Icons.card_giftcard,
                  title: 'Points',
                  trailing: const Text(
                    '10',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,fontSize:16,
                    ),
                  ),
                  onTap: () {Navigator.pushNamed(context, '/point');},
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black45),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              'Contact Us',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12), // تقليل الارتفاع
              ),
              child: const Text(
                'Sign out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}