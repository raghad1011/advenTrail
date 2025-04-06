import 'package:adver_trail/Screens/login.dart';
import 'package:adver_trail/component/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
          icon: const Icon(Icons.arrow_back, color: Color(0xff4f331e),size:32,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xffE6E6E6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Positioned(
                top: 80,
                left: 150,
                child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                "Forget Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900, // Strong bold
                  color: Color(0xff361C0B),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Enter your email to receive a reset link :',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              CustomTextField(
                icon: Icons.email,
                hintText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 20),


      // body: Center(
      //   child: SingleChildScrollView(
      //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //     Positioned(
      //           top: 80,
      //           left: 150,
      //           child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
      //         ),
      //       // Title
      //         const Text(
      //           "Forget Password",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.w900, // Strong bold
      //             color: Color(0xff361C0B),
      //           ),
      //         ),
      //       const Text(
      //         'Enter your email to receive a reset link',
      //         style: TextStyle(fontSize: 18),
      //       ),
      //       SizedBox(height: 20),
      //       TextFormField(
      //         controller: emailController,
      //         decoration: InputDecoration(
      //           labelText: 'Email',
      //           border: OutlineInputBorder(),
      //         ),
      //       ),
      //       SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  await sendSignInLinkToEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email link sent to $email')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your email')),
                  );
                }
                Future.delayed(
                  const Duration(seconds: 3),
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                  },
                );
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
    //final FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

    //   ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    //     url: 'https://adventrail.page.link/forgot_password', // رابط ديناميكي
    //     handleCodeInApp: true,
    //     androidPackageName: 'com.example.adventrail', // اسم الحزمة لتطبيقك
    //     androidInstallApp: true,
    //     androidMinimumVersion: '21',
    //     iOSBundleId: 'com.example.adventrail', // iOS Bundle ID إذا كنت تدعم iOS
    //   );
    //
    //   try {
    //     await auth.sendSignInLinkToEmail(
    //       email: email,
    //       actionCodeSettings: actionCodeSettings,
    //     );
    //     print('Email sign-in link sent!');
    //   } catch (e) {
    //     print('Failed to send email sign-in link');
    //   }
    // }
  }
}