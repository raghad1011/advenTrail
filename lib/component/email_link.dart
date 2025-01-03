import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailLinkHandler extends StatelessWidget {
  const EmailLinkHandler({super.key});

  @override
  Widget build(BuildContext context) {
    handleEmailLink(context);
    return const Scaffold(
      body: Center(
        child: Text('Processing email link...'),
      ),
    );
  }

  Future<void> handleEmailLink(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.isSignInWithEmailLink(Uri.base.toString())) {
      String email = 'user@example.com'; // البريد الإلكتروني المستخدم

      try {
        await auth.signInWithEmailLink(
          email: email,
          emailLink: Uri.base.toString(),
        );
        print('Successfully signed in!');
        Navigator.pushReplacementNamed(context, '/forgot_password');
      } catch (e) {
        print('Error signing in with email link: $e');
      }
    } else {
      print('Invalid or missing email link');
    }
  }
}
