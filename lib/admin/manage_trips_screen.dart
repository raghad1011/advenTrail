import 'dart:developer';

import 'package:adver_trail/model/trips.dart';
import 'package:adver_trail/network/firebase_services.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../Screens/appBar/notification.dart';
import 'add_edit_trip.dart';

class ManageTripsScreen extends StatefulWidget {
  @override
  _ManageTripsScreenState createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EEDC), // بيج
      appBar: AppBar(
        backgroundColor: Color(0xFF6D8B5D), // زيتي
        title: Text('Manage Trips', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: TripList(firebaseService: _firebaseService),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6D8B5D),
        onPressed: () => navigateToAddEditTrip(context, null),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void navigateToAddEditTrip(BuildContext context, TripsModel? trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTripScreen(
          firebaseService: _firebaseService,
          trip: trip,
        ),
      ),
    ).then((value) => setState(() {}));
  }
}

class TripList extends StatelessWidget {
  final FirebaseService firebaseService;

  const TripList({Key? key, required this.firebaseService}) : super(key: key);

  void tripInfo(BuildContext context, Map<String, dynamic> tripData) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFF5EEDC),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tripData['name'] ?? '',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              if (tripData['imageUrl'] != null && tripData['imageUrl'] != '')
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      tripData['imageUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              _infoRow('Category', tripData['category']),
              _infoRow('Price', tripData['price']?.toString() ?? 'N/A'),
              _infoRow('Location', tripData['location']),
              _infoRow('Latitude',
                  tripData['trailRoute']?.latitude?.toString() ?? ''),
              _infoRow('Longitude',
                  tripData['trailRoute']?.longitude?.toString() ?? ''),
              _infoRow('Difficulty', tripData['difficulty']),
              _infoRow('Accessibility', tripData['accessbility'] ?? ''),
              _infoRow('Distance', tripData['distance']),
              _infoRow('Duration', tripData['duration']),
              _infoRow('maxGuests', tripData['maxGuests'].toString()),
              _infoRow('Trip Date', _formatTimestamp(tripData['tripDate'])),
              _infoRow('tripStatus', tripData['tripStatus'] ?? 'N/A'),
              SizedBox(height: 10),
              Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(tripData['description'] ?? 'No description available.'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String? _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime dateTime = timestamp.toDate();
      return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
    }
    return null;
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value ?? '', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripsModel>>(
      future: firebaseService
          .getAllTrips()
          .then((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading trips: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No trips available.'));
        }

        final trips = snapshot.data!;
        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Slidable(
                key: ValueKey(trip.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditTripScreen(
                              firebaseService: firebaseService,
                              trip: trip,
                            ),
                          ),
                        ).then((value) {
                          if (context.findAncestorStateOfType<
                                  _ManageTripsScreenState>() !=
                              null) {
                            context
                                .findAncestorStateOfType<
                                    _ManageTripsScreenState>()!
                                .setState(() {});
                          }
                        });
                      },
                      backgroundColor: Color(0xFFB7C9A8),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (_) =>
                          _showDeleteConfirmationDialog(context, trip.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (_) => _showCancelConfirmationDialog(context, trip),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.cancel,
                      label: 'Cancel',
                    ),

                  ],
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    title: Text(trip.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${trip.location}, ${trip.difficulty}'),
                    onTap: () {
                      tripInfo(context, trip.toJson());
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCancelConfirmationDialog(BuildContext context, TripsModel trip) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: const Text('Are you sure you want to cancel this trip?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes, Cancel'),
              onPressed: () async {
                try {
                  // Check authentication
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    throw Exception('No authenticated user. Please log in.');
                  }
                  log('Authenticated user: ${currentUser.uid}');

                  // Update trip status to canceled
                  log('Updating trip ${trip.id} to canceled status');
                  await FirebaseFirestore.instance
                      .collection('trips')
                      .doc(trip.id)
                      .update({'tripStatus': 'canceled'});

                  // Verify trip update
                  final tripDoc = await FirebaseFirestore.instance
                      .collection('trips')
                      .doc(trip.id)
                      .get();
                  if (tripDoc.data()?['tripStatus'] != 'canceled') {
                    throw Exception('Failed to update trip status');
                  }
                  log('Trip ${trip.id} status updated to canceled');

                  // Fetch bookings for the trip
                  final bookingsSnapshot = await firebaseService.getBookingsForTrip(trip.id);
                  log('Found ${bookingsSnapshot.docs.length} bookings for trip ${trip.id}');

                  if (bookingsSnapshot.docs.isEmpty) {
                    log('No bookings found for trip ${trip.id}. No notifications will be sent.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No bookings found for trip ${trip.name}.')),
                    );
                  }

                  // Send notification to each booked user
                  int successCount = 0;
                  for (var doc in bookingsSnapshot.docs) {
                    final booking = doc.data() as Map<String, dynamic>;
                    log('Booking data: $booking');

                    // Safely extract userId
                    if (!booking.containsKey('userId')) {
                      log('Booking ${doc.id} missing userId field');
                      continue;
                    }

                    final userIdField = booking['userId'];
                    String? userId;

                    if (userIdField is DocumentReference) {
                      userId = userIdField.id;
                    } else if (userIdField is String) {
                      userId = userIdField;
                    } else {
                      log('Invalid userId type in booking ${doc.id}: ${userIdField.runtimeType}');
                      continue;
                    }

                    log('Sending notification to user: $userId for trip: ${trip.name}');

                    final success = await NotificationScreen.sendNotificationToUser(
                      userId: userId,
                      title: 'Trip Canceled',
                      message: 'The trip "${trip.name}" has been canceled due to weather.',
                      tripId: trip.id,
                      type: 'cancellation',
                    );

                    if (success) {
                      successCount++;
                      log('Notification sent successfully to user: $userId');
                    } else {
                      log('Failed to send notification to user: $userId');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to notify user: $userId')),
                      );
                    }
                  }

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        bookingsSnapshot.docs.isEmpty
                            ? 'Trip canceled, but no bookings found.'
                            : 'Trip canceled and $successCount user(s) notified!',
                      ),
                    ),
                  );

                  if (context.findAncestorStateOfType<_ManageTripsScreenState>() != null) {
                    context
                        .findAncestorStateOfType<_ManageTripsScreenState>()!
                        .setState(() {});
                  }
                } catch (e, stackTrace) {
                  log('Error canceling trip or sending notifications: $e', error: e, stackTrace: stackTrace);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error canceling trip: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String tripId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await firebaseService.deleteTrip(tripId);
                if (context
                        .findAncestorStateOfType<_ManageTripsScreenState>() !=
                    null) {
                  context
                      .findAncestorStateOfType<_ManageTripsScreenState>()!
                      .setState(() {});
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trip deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}