// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:adver_trail/Screens/signup.dart';
import 'package:adver_trail/component/main_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin/admin_home.dart';
import '../component/custom_text_field.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
        body: Stack(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/onborad3.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.27, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Embark on Your Journey: Login to Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MediaQuery.removeViewInsets(
                removeBottom: true,
                context: context,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        CustomTextField(
                          icon: Icons.email_outlined,
                          hintText: 'ex: user@example.com',
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CustomTextField(
                          icon: Icons.lock_outline,
                          hintText: '****',
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "this field required";
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Get.to(() => NewpasswordScreen()),
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await signIn(
                                context,
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.brown[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => SignupScreen()),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> signIn(
    BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    // ❗تعليق التحقق من التفعيل لا يزال هنا — فعّل عند الحاجة
    // if (!userCredential.user!.emailVerified) {
    //   await FirebaseAuth.instance.signOut();
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       title: Text("Email Not Verified"),
    //       content: Text("Please verify your email address before logging in."),
    //       actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
    //     ),
    //   );
    //   return;
    // }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .get();

    if (userDoc.exists) {
      String? role = userDoc['role'] as String?;

      if (role == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Role is missing in the user data")),
        );
        return;
      }

      if (role == 'admin') {
        Get.offAll(() => AdminHomeScreen());
      } else {
        Get.offAll(() => MainLayout());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User data not found")),
      );
    }
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException code: ${e.code}');
    String errorMessage;

    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Incorrect password.';
    } else {
      errorMessage = 'Authentication error: ${e.message}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unexpected error: ${e.toString()}")),
    );
  }
}