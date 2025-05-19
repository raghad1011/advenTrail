import 'package:adver_trail/Screens/login.dart';
import 'package:adver_trail/component/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewpasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  NewpasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff4f331e),
            size: 32,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Forget Password',
          style: TextStyle(
            color: Color(0xff4f331e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xffE6E6E6),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to receive a reset link :',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            CustomTextField(
              icon: Icons.email,
              hintText: 'Email',
              controller: emailController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    try {
                      await sendSignInLinkToEmail();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email link sent to $email')),
                      );
                      await Future.delayed(Duration(seconds: 3));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to send email: ${e.toString()}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your email')),
                    );
                  }
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Send Link',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> sendSignInLinkToEmail() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text);
  }
}
