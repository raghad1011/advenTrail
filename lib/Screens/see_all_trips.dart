import 'package:adver_trail/Screens/trip_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/trips.dart';
import '../component/trip_card.dart';
import '../network/firebase_services.dart';

class SeeAllTripsPage extends StatefulWidget {
  const SeeAllTripsPage({super.key});

  @override
  State<SeeAllTripsPage> createState() => _SeeAllTripsPageState();
}

class _SeeAllTripsPageState extends State<SeeAllTripsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<TripsModel>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = loadTrips();
  }

  Future<List<TripsModel>> loadTrips() async {
    final snapshot = await _firebaseService.getAllTrips();
    final now = DateTime.now();

    return snapshot.docs.map((doc) => doc.data()).where((trip) {
      final tripDate = trip.tripDate?.toDate();
      if (tripDate == null) return false;
      return tripDate.isAfter(now) || tripDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'See All Trips',
          style: TextStyle(
            color: Color(0xff361C0B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<TripsModel>>(
        future: _tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading trips'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trips found'));
          }

          final trips = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Get.off(TripDetailsPage(trip: trip)),
                  child: TripCard(trip: trip),
                ),
              );
            },
          );
        },
      ),
    );
  }
}