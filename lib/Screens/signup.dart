
import 'package:adver_trail/component/custom_text_field.dart';
import 'package:adver_trail/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPassword = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? errorMessage;
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signupKey,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background image
            Image.asset(
              'assets/images/onborad3.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
            ),

            // Header Text
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Join the Exploration: Sign Up for Free',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Form Container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MediaQuery.removeViewInsets(
                removeBottom: true,
                context: context,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
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
                          if (errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                          _buildLabel("User Name"),
                          CustomTextField(
                            icon: Icons.person_2_outlined,
                            hintText: 'Input user name here',
                            controller: usernameController,
                            validator: (p0) => p0!.isEmpty
                                ? "please enter a user name"
                                : null,
                          ),
                          const SizedBox(height: 8),
                          _buildLabel("Email"),
                          CustomTextField(
                            icon: Icons.email_outlined,
                            hintText: 'ex: user@example.com',
                            controller: emailController,
                            validator: (p0) =>
                            p0!.isEmpty ? "Email is required" : null,
                          ),
                          const SizedBox(height: 8),
                          _buildLabel("Phone Number"),
                          CustomTextField(
                            icon: Icons.phone,
                            hintText: 'Phone Number',
                            controller: phoneController,
                            validator: (p0) => p0!.isEmpty
                                ? "please enter your phone number"
                                : null,
                          ),
                          const SizedBox(height: 8),
                          _buildLabel("Password"),
                          CustomTextField(
                            icon: Icons.lock_outline,
                            hintText: '****',
                            obscureText: true,
                            controller: passwordController,
                            validator: (p0) {
                              if (p0!.isEmpty) return "please enter your password";
                              if (p0.length < 8) return "the password is less than 8";
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildLabel("Confirm Password"),
                          CustomTextField(
                            icon: Icons.lock_outline,
                            hintText: '****',
                            obscureText: true,
                            controller: conPassword,
                            validator: (p0) {
                              if (p0!.isEmpty) return "please enter your password";
                              if (passwordController.text != conPassword.text) {
                                return "The password does not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (signupKey.currentState!.validate()) {
                                await signUp(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.brown[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already Have Account? ",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => const LoginScreen()),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
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

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': 'user',
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 60),
              const SizedBox(height: 12),
              const Text(
                "Verify your email",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "A verification link has been sent to your email. Please verify before logging in.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const LoginScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}