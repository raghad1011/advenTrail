import 'package:adver_trail/component/build_menu_item.dart';
import 'package:flutter/material.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xff361C0B),
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildMenuItem(
              icon: Icons.question_mark,
              title: 'Help',
              onTap: () {},
            ),
            buildMenuItem(
              icon: Icons.announcement_outlined,
              title: 'About',
              onTap: () {},
            ),
            buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy Policy',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
