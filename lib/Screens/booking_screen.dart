import 'package:adver_trail/Screens/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/booking.dart';
import '../model/trips.dart';

class BookingBottomSheet extends StatefulWidget {
  final TripsModel trip;

  const BookingBottomSheet({super.key, required this.trip});

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  int selectedGuests = 1;
  int bookedGuests = 0;
  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchBookedGuests();
    getCurrentUser(); // Get user info on init
  }

  // Fetch the current logged-in user's ID
  Future<void> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        userId = user?.uid ?? '';
      });
    } catch (e) {
      print("Error getting user: $e");
    }
  }

  Future<void> fetchBookedGuests() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('tripId', isEqualTo: FirebaseFirestore.instance.doc('trips/${widget.trip.id}'))
          .where('is_deleted', isEqualTo: false)
          .get();

      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['numberOfGuests'] ?? 0) as int;
      }

      setState(() {
        bookedGuests = total;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching bookings: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> saveBooking() async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not logged in!')));
      return;
    }

    final bookingData = BookingModel(
      tripId: FirebaseFirestore.instance.doc('trips/${widget.trip.id}'),
      userId: FirebaseFirestore.instance.doc('users/$userId'),  // Use the current user ID
      price: (widget.trip.price ?? 0) * selectedGuests,
      numberOfGuests: selectedGuests,
      status: 'Confirmed',
      bookingDate: Timestamp.now(),
      tripDate: widget.trip.tripDate,
      is_deleted: false,
    );

    try {
      // Add booking to Firestore
      final docRef = await FirebaseFirestore.instance.collection('bookings').add(bookingData.toJson());

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed!')));

      // Close the bottom sheet
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxGuests = widget.trip.maxGuests ?? 1;
    final availableSpots = maxGuests - bookedGuests;
    final pricePerGuest = (widget.trip.price ?? 0).toDouble();
    final totalPrice = selectedGuests * pricePerGuest;

    return isLoading
        ? const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    )
        : Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Confirm Booking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Spots: $availableSpots'),
              Text('Price/Guest: \$${pricePerGuest.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            value: selectedGuests,
            decoration: const InputDecoration(
              labelText: 'Number of Guests',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedGuests = value;
                });
              }
            },
            items: List.generate(
              availableSpots,
                  (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Total: \$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              selectedGuests <= availableSpots
                  ? () {
                saveBooking();
              }
                  : null,
              child: const Text('Confirm Booking'),
            ),
          ),
        ],
      ),
    );
  }
}