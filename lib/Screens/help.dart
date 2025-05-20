import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need assistance using AdvenTrail?\nHere are answers to some frequently asked questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              _buildHelpCard(
                question: '🔹 How do I book a trip?',
                answer:
                    'Go to the “Trips” section, select a trip, tap on "Book Now", and upload your payment proof to confirm your reservation.',
              ),
              _buildHelpCard(
                question: '🔹 How do I check my booking status?',
                answer:
                    'Visit the “My Bookings” section to view all your active, pending, or canceled trips.',
              ),
              _buildHelpCard(
                question: '🔹 I forgot my password. What should I do?',
                answer:
                    'On the login screen, tap “Forgot Password” and follow the steps to reset your password via email.',
              ),
              _buildHelpCard(
                question: '🔹 How can I cancel a trip?',
                answer:
                    'If the trip hasn’t started yet, go to “My Bookings”, select the trip, and tap “Cancel Booking”.',
              ),
              _buildHelpCard(
                question: '🔹 What if there’s an emergency during a trip?',
                answer:
                    'Use the in-app notification feature or location sharing to alert the trip admin immediately.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Still need help?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can contact our support team via email:\nadventrail.support@gmail.com\nWe’re always happy to help!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard({required String question, required String answer}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}