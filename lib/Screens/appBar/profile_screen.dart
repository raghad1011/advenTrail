import 'package:adver_trail/Screens/bottomBar/user_trip_history.dart';
import 'package:adver_trail/Screens/forgot_password.dart';
import 'package:adver_trail/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/build_menu_item.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          buildMenuItem(
            icon: Icons.person_pin_outlined,
            title: "Edit Profile",
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                final data = snapshot.data();
                if (data != null) {
                  showEditProfileBottomSheet(context, {
                    'uid': user.uid,
                    'name': data['name'],
                    'email': data['email'],
                    'phone': data['phone'],
                  });
                }
              }
            },
          ),
          buildMenuItem(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () => Get.to(() => NewpasswordScreen()),
          ),
          buildMenuItem(
              icon: Icons.history,
              title: "History",
              onTap: () => Get.to(() => NewpasswordScreen()),
          ),
          Divider(),
          buildMenuItem(
            icon: Icons.logout,
            title: "Logout",
            color: Colors.brown,
            onTap: () => showDeleteConfirmationDialog(context),
          ),
        ]),
      ),
    );
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout',
              style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          content: Text(
            'Are you sure to logout this account',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: TextButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => LoginScreen());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
