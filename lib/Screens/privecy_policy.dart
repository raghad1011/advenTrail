import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and safeguard your information within our application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Information We Collect:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- Information you provide directly such as name, email, etc.\n'
              '- Data automatically collected like device type, OS, and usage logs.',
            ),
            SizedBox(height: 16),
            Text(
              '2. How We Use Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- To provide and improve our services.\n'
              '- To respond to user inquiries.\n'
              '- To send notifications or app updates.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Information Sharing:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- We do not share your information with third parties except with your consent or as required by law.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Information Security:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- We use security measures to protect your data from unauthorized access.',
            ),
            SizedBox(height: 16),
            Text(
              '5. User Rights:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- You can request to access, modify, or delete your personal data.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Cookies:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- We may use cookies to enhance user experience.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Policy Updates:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- We may update this policy from time to time. You will be notified of any changes.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Contact Us:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '- For any inquiries, please contact us at: info@example.com',
            ),
            SizedBox(height: 30),
            Text(
              'Last Updated: May 20, 2025',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}