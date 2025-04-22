import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adver_trail/model/trips.dart';
import 'trip_details_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<TripsModel> allTrips = [];
  List<TripsModel> filteredTrips = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    final snapshot = await FirebaseFirestore.instance.collection('trips').get();
    final trips = snapshot.docs.map((doc) {
      final data = doc.data();
      return TripsModel(
        id: doc.id,
        name: data['name'],
        price: data['price'],
        description: data['description'],
        location: data['location'],
        trailRoute: data['trailRoute'],
        difficulty: data['difficulty'],
        duration: data['duration'],
        status: data['status'],
        imageUrl: data['imageUrl'],
        tripDate: data['tripDate'],
        accessibility: data['accessibility'],
        category: data['category'],
        distance: data['distance'],
        maxGuests: data['maxGuests'],
      );
    }).toList();
    setState(() {
      allTrips = trips;
      filteredTrips = trips;
    });
  }

  void searchTrips(String text) {
    final results = allTrips.where((trip) {
      final name = trip.name.toLowerCase();
      final location = trip.location.toLowerCase();
      final level = trip.difficulty.toLowerCase();
      final input = text.toLowerCase();
      return name.contains(input) || location.contains(input) || level.contains(input);
    }).toList();

    setState(() {
      query = text;
      filteredTrips = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffD1C4B9),
        title: TextField(
          onChanged: searchTrips,
          decoration: const InputDecoration(
            hintText: 'Search for trips...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: filteredTrips.isEmpty
          ? const Center(child: Text("No trips found"))
          : ListView.builder(
        itemCount: filteredTrips.length,
        itemBuilder: (context, index) {
          final trips = filteredTrips[index];
          return ListTile(
            leading: const Icon(Icons.landscape),
            title: Text(trips.name,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            subtitle: Text('${trips.location} • ${trips.difficulty}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailsPage(
                      trip: trips,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}