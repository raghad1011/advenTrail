import 'package:adver_trail/Screens/bottomBar/user_trip_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:get/get.dart';
import '../model/booking.dart';
import '../model/trips.dart';

class BookingBottomSheet extends StatefulWidget {
  final TripsModel trip;

  const BookingBottomSheet({super.key, required this.trip});

  @override
  BookingBottomSheetState createState() => BookingBottomSheetState();
}

class BookingBottomSheetState extends State<BookingBottomSheet> {
  int selectedGuests = 1;
  int bookedGuests = 0;
  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchBookedGuests();
    getCurrentUser();
  }

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
          .where('tripId',
              isEqualTo:
                  FirebaseFirestore.instance.doc('trips/${widget.trip.id}'))
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

  Future<void> createBookingAndRedirect() async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User not logged in!')));
      return;
    }

    final now = DateTime.now();
    final tripDate = widget.trip.tripDate!.toDate();

    if (tripDate.isBefore(now)) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot book a trip in the past!')),
      );
      return;
    }

    final bookingData = BookingModel(
      tripId: FirebaseFirestore.instance.doc('trips/${widget.trip.id}'),
      userId: FirebaseFirestore.instance.doc('users/$userId'),
      price: (widget.trip.price ?? 0) * selectedGuests,
      numberOfGuests: selectedGuests,
      status: 'waiting',
      bookingDate: Timestamp.now(),
      tripDate: widget.trip.tripDate,
      is_deleted: false,
    );

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created, go to My Bookings to confirm payment.')),
      );
      Get.to(UserTripHistoryPage(userId: userId));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxGuests = widget.trip.maxGuests ?? 1;
    final availableSpots = (maxGuests - bookedGuests).clamp(0, maxGuests);
    final pricePerGuest = (widget.trip.price ?? 0).toDouble();
    final totalPrice = selectedGuests * pricePerGuest;

    if (!isLoading && availableSpots == 0) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Sorry, this trip is fully booked.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                    'Close', style: TextStyle(color: Colors.black87)),
              ),
            )
          ],
        ),
      );
    }

    return isLoading
        ? const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    )
        : Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const Text(
            'Confirm Booking',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            widget.trip.name,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Spots: $availableSpots'),
              Text('Price/Guest: \$${pricePerGuest.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 28),
                onPressed: selectedGuests > 1
                    ? () {
                  setState(() {
                    selectedGuests--;
                  });
                }
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$selectedGuests',
                  style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 28),
                onPressed: selectedGuests < availableSpots
                    ? () {
                  setState(() {
                    selectedGuests++;
                  });
                }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaypalCheckoutView(
                      sandboxMode: true,
                      clientId: "AXtymB8YgR2x4n0MSIlYSL_QML4zbq3TKAbSqKRlFQIQ7kxcwlyHGe3WdaaH6uF9459LRqx7UsK1FFVe",
                      secretKey: "EIsbJmNZgvNNhB6nHMUXHGgmWk6xROYKoNvIBUw7yl7bQ2dwu9dfDQpOGrUYpWwRfGR4P4LxSnYy-dIr",
                      transactions: [
                        {
                          "amount": {
                            "total": widget.trip.price,
                            "currency": "USD",
                            "details": {
                              "subtotal": widget.trip.price,
                              "shipping": "0",
                              "shipping_discount": 0
                            }
                          },
                          "description": "حجز: ${widget.trip.name}",
                          "item_list": {
                            "items": [
                              {
                                "name": widget.trip.name,
                                "quantity": 1,
                                "price": widget.trip.price,
                                "currency": "USD"
                              }
                            ]
                          }
                        }
                      ],
                      note: "شكراً لاستخدامك تطبيقنا!",
                      onSuccess: (params) {
                        print("نجحت عملية الدفع: $params");
                        Navigator.pop(context);
                        // ممكن ترسلي الحجز إلى Firebase هنا
                      },
                      onError: (error) {
                        print("خطأ في الدفع: $error");
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        print("تم إلغاء الدفع");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Color(0xFF556B2F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle_outline,color: Colors.white,),
              label: const Text(
                'Pay and Book Now',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
