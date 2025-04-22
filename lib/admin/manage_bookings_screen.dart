import 'package:adver_trail/model/booking.dart';
import 'package:adver_trail/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageBookingsScreen extends StatefulWidget {
  @override
  _ManageBookingsScreenState createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings'),
      ),
      body: FutureBuilder<QuerySnapshot<BookingModel>>(
        future: _firebaseService.getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading bookings: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings available.'));
          }

          final bookings = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data();
              return FutureBuilder<DocumentSnapshot?>(
                future: _firebaseService.getUser(booking.userId?.id ?? ''),
                builder: (context, userSnapshot) {
                  String userName = 'Loading...';
                  if (userSnapshot.connectionState == ConnectionState.done &&
                      userSnapshot.hasData) {
                    // userName = userSnapshot.data?.get('') ?? 'Unknown User';

                    userName = (userSnapshot.data?.data()
                            as Map<String, dynamic>?)?['name'] ??
                        'Unknown User';
                  } else if (userSnapshot.hasError) {
                    userName = 'Error loading user';
                  }

                  return FutureBuilder<DocumentSnapshot<Object?>?>(
                    future: booking.tripId?.get(),
                    builder: (context, tripSnapshot) {
                      String tripName = 'Loading...';
                      Timestamp? tripDate;

                      if (tripSnapshot.connectionState == ConnectionState.done &&
                          tripSnapshot.hasData) {
                        final tripData = tripSnapshot.data?.data() as Map<String, dynamic>?;
                        tripName = tripData?['name'] ?? 'Unknown Trip';
                        tripDate = tripData?['tripDate'];
                      } else if (tripSnapshot.hasError) {
                        tripName = 'Error loading trip';
                      }

                      return ListTile(
                        title: Text('Trip: $tripName'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User: $userName'),
                            Text(
                                'Booked on: ${booking.bookingDate != null
                                    ? DateFormat('yyyy-MM-dd – hh:mm a').format(booking.bookingDate!.toDate())
                                    : 'N/A'}'),
                            Text(
                                'Trip Time: ${tripDate != null
                                    ? DateFormat('yyyy-MM-dd – hh:mm a').format(tripDate.toDate())
                                    : 'N/A'}'),
                            Text('Guests: ${booking.numberOfGuests ?? 'N/A'}'),
                            Text(
                              'Status: ${booking.status ?? 'N/A'}',
                              style: TextStyle(
                                color: booking.status == 'Confirmed'
                                    ? Colors.green
                                    : booking.status == 'Cancelled'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                            Text('Price: ${booking.price != null ? '\$${booking.price}' : 'N/A'}'),
                          ],
                        ),

                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, booking.id!);
                          },
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String bookingId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this booking?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _firebaseService.deleteBooking(bookingId);
                // Refresh the booking list
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
