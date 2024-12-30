import 'package:flutter/material.dart';
import '../afterhomsecreen2/edit_profile.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body:  Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            _buildSettingsOption(
              icon: Icons.person,
              label: 'Edit profile',
              onTap: () {
                // Navigate to EditProfileScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
            ),const SizedBox(height: 15,),
            _buildSettingsToggle(
              icon: Icons.dark_mode,
              label: 'Dark Mode',
              value: true,
              onChanged: (value) {},
            ),const SizedBox(height: 15,),
            _buildSettingsOption(
              icon: Icons.language,
              label: 'Language',
              onTap: () {},
            ),
            _buildSettingsToggle(
              icon: Icons.notifications,
              label: 'Allow Notifications',
              value: false,
              onChanged: (value) {},
            ),const SizedBox(height: 15,),
            _buildSettingsOption(
              icon: Icons.info,
              label: 'About us',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }

  Widget _buildSettingsToggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black,size: 32,),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: Colors.brown,
        onChanged: onChanged,
      ),
    );
  }