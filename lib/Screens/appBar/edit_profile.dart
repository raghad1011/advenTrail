import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../component/profile_text_field.dart';

void showEditProfileBottomSheet(
    BuildContext context, Map<String, dynamic> userData) {
  final nameController = TextEditingController(text: userData['name']);
  final emailController = TextEditingController(text: userData['email']);
  final phoneController = TextEditingController(text: userData['phone']);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              ProfileTextField(
                controller: nameController,
                labelText: 'User Name',
                hintText: 'Enter your name',
              ),
              SizedBox(height: 5),
              ProfileTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              SizedBox(height: 5),
              ProfileTextField(
                controller: phoneController,
                labelText: 'Phone',
                hintText: 'Enter your phone number',
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userData['uid'])
                        .update({
                      'name': nameController.text.trim(),
                      'email': emailController.text.trim(),
                      'phone': phoneController.text.trim(),
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
