import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/booking.dart';
import '../network/firebase_services.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      appBar: AppBar(
        title: const Text('Manage Bookings'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D8B5D),),
      body: FutureBuilder<QuerySnapshot<BookingModel>>(
        future: _firebaseService.getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading bookings: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings available.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data();
              return FutureBuilder<DocumentSnapshot?>(
                future: _firebaseService.getUser(booking.userId?.id ?? ''),
                builder: (context, userSnapshot) {
                  String userName = 'Loading...';
                  if (userSnapshot.connectionState == ConnectionState.done &&
                      userSnapshot.hasData) {
                    userName = (userSnapshot.data?.data()
                    as Map<String, dynamic>?)?['name'] ??
                        'Unknown User';
                  } else if (userSnapshot.hasError) {
                    userName = 'Error loading user';
                  }

                  return FutureBuilder<DocumentSnapshot?>(
                    future: booking.tripId?.get(),
                    builder: (context, tripSnapshot) {
                      String tripName = 'Loading...';
                      Timestamp? tripDate;

                      if (tripSnapshot.connectionState == ConnectionState.done &&
                          tripSnapshot.hasData) {
                        final tripData = tripSnapshot.data?.data() as Map<String, dynamic>?;
                        tripName = tripData?['name'] ?? 'Unknown Trip';
                        tripDate = tripData?['tripDate'];
                      }

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Trip: $tripName", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          showEditBookingDialog(context, booking);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          showDeleteConfirmationDialog(context, booking.id!);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Divider(),
                              Text("User: $userName"),
                              Text("Booked on: ${booking.bookingDate != null ? DateFormat('yyyy-MM-dd – hh:mm a').format(booking.bookingDate!.toDate()) : 'N/A'}"),
                              Text("Trip time: ${tripDate != null ? DateFormat('yyyy-MM-dd – hh:mm a').format(tripDate.toDate()) : 'N/A'}"),
                              Text("Guests: ${booking.numberOfGuests ?? 'N/A'}"),
                              Text(
                                "Status: ${booking.status ?? 'N/A'}",
                                style: TextStyle(
                                  color: booking.status == 'Confirmed'
                                      ? Colors.green
                                      : booking.status == 'Cancelled'
                                      ? Colors.red
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Price: \$${booking.price ?? 'N/A'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> showEditBookingDialog(BuildContext context, BookingModel booking) async{
    final guestsController = TextEditingController(text: booking.numberOfGuests.toString());
    String? status = booking.status ?? 'Pending';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: guestsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of Guests',),
          ),
          DropdownButtonFormField<String>(
            value: status,
            onChanged: (value) => status = value!,
            items: ['Pending', 'Confirmed', 'Cancelled']
        .map((status) => DropdownMenuItem(value: status,child: Text(status)))
        .toList(),
        decoration: InputDecoration(labelText: 'Status'),
        ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final newNumberOfGuests = int.tryParse(guestsController.text);
                if (newNumberOfGuests != null) {
                  final tripSnapshot = await booking.tripId?.get();
                  final tripData = tripSnapshot?.data() as Map<String, dynamic>?;
                  final pricePerGuest = tripData?['price'] ?? 0;
                  final newPrice = newNumberOfGuests * pricePerGuest;

                  await _firebaseService.updateBooking(booking.id!,{
                    'numberOfGuests': newNumberOfGuests,
                    'status': status,
                    'price': newPrice,
                  });
                  setState(() {
                    booking.numberOfGuests = newNumberOfGuests;
                    booking.status = status;
                    booking.price = newPrice as int?;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking updated successfully!')),
                  );
                }
                },
            ),
          ],
        );
    }
    );
  }


  Future<void> showDeleteConfirmationDialog(BuildContext context, String bookingId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this booking?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _firebaseService.deleteBooking(bookingId);
                setState(() {});
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}