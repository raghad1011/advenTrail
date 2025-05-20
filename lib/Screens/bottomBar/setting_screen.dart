import 'package:adver_trail/Screens/about.dart';
import 'package:adver_trail/Screens/help.dart';
import 'package:adver_trail/Screens/privecy_policy.dart';
import 'package:adver_trail/component/build_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onTap: ()async {
await Get.to(Help());
              },
            ),
            buildMenuItem(
              icon: Icons.announcement_outlined,
              title: 'About',
              onTap: ()async {
               await Get.to(About());
              },
            ),
            buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy Policy',
              onTap: () {
                Get.to(PrivacyPolicyPage());
              },
            ),
            buildMenuItem(
              icon: Icons.format_quote_outlined,
              title: 'Suggested',
              onTap: () async {
                final url = Uri.parse(
                    "https://docs.google.com/forms/d/e/1FAIpQLSfs23MlpfXPOIBu1e3z098hd2i749gBXAy_YUFMRZZIswJAiw/formResponse");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
