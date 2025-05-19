import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/trips.dart';
import '../rating.dart';
import '../trip_details_screen.dart';

class UserTripHistoryPage extends StatefulWidget {
  final String userId;

  const UserTripHistoryPage({super.key, required this.userId});

  @override
  State<UserTripHistoryPage> createState() => _UserTripHistoryPageState();
}

class _UserTripHistoryPageState extends State<UserTripHistoryPage> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String selectedStatus = 'booked';
  Set<String> ratedBookingIds = {};

  @override
  void initState() {
    super.initState();
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    setState(() => isLoading = true);

    Query bookingsQuery = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId',
            isEqualTo:
                FirebaseFirestore.instance.doc('users/${widget.userId}'));

    if (selectedStatus == 'completed') {
      bookingsQuery = bookingsQuery.where('status', whereIn: ['booked']);
    } else if (selectedStatus == 'booked') {
      bookingsQuery = bookingsQuery.where('status', whereIn: ['booked']);
    } else {
      bookingsQuery = bookingsQuery.where('status', isEqualTo: selectedStatus);
    }

    final snapshot = await bookingsQuery.get();

    List<Map<String, dynamic>> result = [];
    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      final bookingData = doc.data() as Map<String, dynamic>;
      final tripRef = bookingData['tripId'] as DocumentReference;
      final tripSnapshot = await tripRef.get();
      if (!tripSnapshot.exists) continue;

      final tripData = tripSnapshot.data() as Map<String, dynamic>;
      final trip = TripsModel.fromJson(tripData)..id = tripRef.id;

      final tripDate = (tripData['tripDate'] as Timestamp).toDate();

      if (selectedStatus == 'completed' && tripDate.isAfter(now)) {
        continue;
      }

      if (selectedStatus == 'booked' && tripDate.isBefore(now)) {
        continue;
      }

      final ratingsSnapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('tripId', isEqualTo: trip.id)
          .where('userId', isEqualTo: widget.userId)
          .get();

      final isRated = ratingsSnapshot.docs.isNotEmpty;

      result.add({
        'trip': trip,
        'date': (bookingData['bookingDate'] as Timestamp).toDate(),
        'bookingId': doc.id,
        'tripDate': tripDate,
        'status': bookingData['status'],
        'price': bookingData['price'],
        'isRated': isRated,
      });
    }

    setState(() {
      bookings = result;
      isLoading = false;
    });
  }

  Future<void> cancelBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({
      'status': 'cancelled',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking cancelled")),
    );

    fetchUserBookings();
  }

  Future<void> confirmPayment(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'booked'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment confirmed")),
    );

    fetchUserBookings();
  }

  void onStatusChanged(String status) {
    setState(() {
      selectedStatus = status;
      ratedBookingIds.clear();
    });
    fetchUserBookings();
  }

  Future<void> confirmCancel(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this booking?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes")),
        ],
      ),
    );

    if (confirmed == true) {
      cancelBooking(bookingId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 10,
                children: [
                  statusTab("Waiting", 'waiting'),
                  statusTab("Booked", 'booked'),
                  statusTab("Cancelled", 'cancelled'),
                  statusTab("Completed", 'completed'),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookings.isEmpty
                    ? const Center(child: Text("No bookings found"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          final trip = booking['trip'] as TripsModel;
                          final bookingDate = booking['date'] as DateTime;
                          final status = booking['status'];
                          final bookingId = booking['bookingId'];
                          final isRated = booking['isRated'] as bool? ?? false;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              onTap: () {
                                Get.to(TripDetailsPage(trip: trip));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  trip.imageUrl ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(trip.name,
                                  style: TextStyle(fontSize: 14)),
                              subtitle: Text("\$${booking['price']}",
                                  style: TextStyle(
                                      color: Colors.brown[800], fontSize: 13)),
                              trailing: getTrailingButton(status, bookingId,
                                  trip.id, bookingDate, trip, isRated),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget statusTab(String label, String value) {
    final isSelected = selectedStatus == value;
    return GestureDetector(
      onTap: () => onStatusChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.brown[800],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget getTrailingButton(String status, String bookingId, String tripId,
      DateTime bookingDate, TripsModel trip, bool isRated) {
    if (status == 'booked') {
      if (selectedStatus == 'completed') {
        if(!isRated) {
          return TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              final rated = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (context) =>
                    RatingBottomSheet(
                      tripId: tripId,
                      userId: widget.userId,
                    ),
              );

              if (rated == true) {
                fetchUserBookings();
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.brown[800]!,
                    Colors.brown[400]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Rate",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }else{
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 5),
              Text(
                "Rated",
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }
      } else {
        return Text(
          DateFormat('dd/MM/yyyy').format(bookingDate),
          style: TextStyle(color: Colors.brown[800]),
        );
      }
    } else if (status == 'waiting') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => confirmPayment(bookingId),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.brown[800]!,
                    Colors.brown[400]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Pay Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.red, size: 18),
            tooltip: "Cancel Trip",
            onPressed: () => confirmCancel(bookingId),
          ),
        ],
      );
  } else if (status == 'cancelled') {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => Get.to(TripDetailsPage(trip: trip)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.brown[800]!,
                Colors.brown[400]!,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Book Again",
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else {
      return const Text("");
    }
  }
}
