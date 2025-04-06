import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false; // Variable to track the checkbox state
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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Positioned(
                //   top: 80,
                //   left: 150,
                Image.asset('assets/images/Group 4.png', width: 90, height: 90),

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
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                CustomTextField(
                  icon: Icons.person,
                  hintText: 'Username',
                  controller: usernameController,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "this field required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Email Field
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
                // const SizedBox(height: 15),
                // TextFormField(
                //   controller: phoneController,
                //   decoration: InputDecoration(
                //     prefixIcon: Icon(Icons.phone),
                //     labelText: 'Phone Number',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (p0) {
                //     if (p0!.isEmpty) {
                //       return "this field required";
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 15),
                CustomTextField(
                  icon: Icons.phone,
                  hintText: 'Phone Number',
                  controller: phoneController,
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
                  //suffixIcon: Icons.visibility,
                  controller: passwordController,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "this field required";
                    } else if (p0.length < 8) {
                      return "the password is less than 8";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Confirm Password Field
                CustomTextField(
                  icon: Icons.lock,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  //suffixIcon: Icons.visibility,
                  controller: conPassword,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "this field required";
                    } else if (passwordController.text != conPassword.text) {
                      return "The password does not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await signUp(context);
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

      // Save additional user info in Firestore (excluding password)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'role': 'user', // Default role
      });
      Navigator.pushReplacementNamed(context, '/bottomNav'); // Navigate to home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

// Future<void> signUp(BuildContext context) async {
//
//   if(signupKey.currentState!.validate()){
//     try {
//       final credential =
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email.text,
//         password: password.text,
//       );
//        CollectionReference collectionReference =
//        FirebaseFirestore.instance.collection('users');
//        General.user= AppUser(
//          emal: email.text,
//          userName: username.text,
//        );
//       collectionReference.doc(credential.user!.uid).set(General.user!.toJson());
//        log(credential.user!.uid);
//       showDialog(
//         barrierColor: Colors.transparent,
//         barrierDismissible: false,
//         context: context,
//         builder: (context) {
//           return Material(
//             color: Colors.white.withAlpha(0),
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(vertical: MediaQuery
//                   .sizeOf(context)
//                   .height * (4 / 10), horizontal: 60),
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
//       Future.delayed(Duration(seconds: 3),() {
//         Navigator.pop(context);
//         Navigator.pushNamed(context, '/bottomNav');
//       },);
//
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('The account already exists for that email.')),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
}
