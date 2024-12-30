import 'package:flutter/material.dart';
import '../component/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false; // Variable to track the checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
            backgroundColor: Colors.grey[100],

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
                "Take the first step and explore the untamed beauty of Jordan's hidden trails!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900, // Strong bold
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              // Username Field              
              const CustomTextField(
                icon: Icons.person,
                hintText: 'Username',
              ),
              const SizedBox(height: 15),
              // Email Field
              const CustomTextField(
                icon: Icons.email,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),
              // Password Field
              const CustomTextField(
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              const SizedBox(height: 15),
              // Confirm Password Field
              const CustomTextField(
                icon: Icons.lock,
                hintText: 'Confirm Password',
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Checkbox(
                    value: isChecked, // Bind the checkbox to the state variable
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false; // Update the state when checkbox is pressed
                      });
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text: "I Agree with ",
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "privacy and policy",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.brown[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Text
              
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Log in",
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
    );
  }
}