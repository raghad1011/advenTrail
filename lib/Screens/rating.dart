import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingBottomSheet extends StatefulWidget {
  final String tripId;
  final String userId;

  const RatingBottomSheet({
    super.key,
    required this.tripId,
    required this.userId
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double rating = 0;
  String? comment;

  Future<void> submitRating() async {
    if (rating == 0) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ratingData = {
      'tripId': widget.tripId,
      'userId': widget.userId,
      'rating': rating,
      'comment': comment ?? '',
      'date': Timestamp.now(),
    };

    final tripRef = FirebaseFirestore.instance.collection('trips').doc(widget.tripId);
    final ratingRef = FirebaseFirestore.instance.collection('ratings');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(tripRef);
      double currentAverage = snapshot.data()?['averageRating']?.toDouble() ?? 0.0;
      int currentCount = snapshot.data()?['ratingCount']?.toInt() ?? 0;

      double newAverage = ((currentAverage * currentCount) + rating) / (currentCount + 1);
      int newCount = currentCount + 1;

      transaction.update(tripRef, {
        'averageRating': newAverage,
        'ratingCount': newCount,
      });

      ratingRef.add(ratingData);
    });

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (newRating) {
              setState(() => rating = newRating);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (val) => comment = val,
            decoration: const InputDecoration(hintText: 'Leave a comment (optional)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: submitRating,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
