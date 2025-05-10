import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialog extends StatefulWidget {
  final String tripId;
  final String bookingId;

  const RatingDialog({
    super.key,
    required this.tripId,
    required this.bookingId,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0;

  Future<void> submitRating() async {
    if (rating > 0) {
      if (widget.tripId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip ID is missing')),
        );
        return;
      }

      final tripRef =
      FirebaseFirestore.instance.collection('trips').doc(widget.tripId);

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
      });

      Navigator.of(context).pop(); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks for your rating!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate your experience'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
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