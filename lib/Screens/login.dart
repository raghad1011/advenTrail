import 'package:adver_trail/admin/admin_home.dart';
import 'package:adver_trail/component/custom_bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/custom_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isChecked = false; // Variable to track the checkbox state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/Group 4.png', width: 90, height: 90),

                const SizedBox(height: 20),
                // Title
                const Text(
                  "Log in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900, // Strong bold
                    color: Color(0xff361C0B),
                  ),
                ),
                const SizedBox(height: 30),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                CustomTextField(
                  icon: Icons.email,
                  hintText: 'Email',
                  controller: emailController,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "this field required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Password Field
                CustomTextField(
                  icon: Icons.lock,
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "this field required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  // لتحريك النص إلى الطرف الأيمن
                  child: GestureDetector(
                    onTap: () {
                      // هنا التنقل إلى صفحة "نسيت كلمة المرور"
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: const Text(
                      '            Forgot Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Log In Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add navigation to the next screen, for example:
                      if (formKey.currentState!.validate()) {
                        await signIn(context, emailController.text.trim(), passwordController.text.trim());

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/signup'); // Navigate to sign up page
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password.trim());

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)  // Safely access UID
          .get();

      if (userDoc.exists) {
        // Check for the 'role' field in Firestore and cast it to String
        String? role = userDoc['role'] as String?;

        if (role == null) {
          // Handle case if role is missing
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Role is missing in the user data")),
          );
          return;
        }

        // Navigate based on the role
        if (role == 'admin') {
          Get.offAll(AdminHomeScreen());
        } else {
          Get.offAll(HomePage());
        }
      } else {
        // Handle case where user document is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User data not found")),
        );
      }
    } catch (e) {
      // Handle authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

// Future<void> logIn(
  //     BuildContext context, String email, String password) async {
  //   try {
  //     final credential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     if (credential.user!.uid.isNotEmpty) {
  //       showDialog(
  //         barrierColor: Colors.transparent,
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) {
  //           return Material(
  //             color: Colors.white.withAlpha(0),
  //             child: Container(
  //               alignment: Alignment.center,
  //               margin: EdgeInsets.symmetric(
  //                   vertical: MediaQuery.sizeOf(context).height * (4 / 10),
  //                   horizontal: 60),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[200],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: const Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Loading...",
  //                     style: TextStyle(fontSize: 15, color: Colors.black),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   CircularProgressIndicator(),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //       Future.delayed(
  //         Duration(seconds: 3),
  //         () {
  //           Navigator.pop(context);
  //           Navigator.pushNamed(context, '/bottomNav');
  //         },
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }
}