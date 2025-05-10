import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adver_trail/model/trips.dart';
import 'package:get/get.dart';
import '../component/trip_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<TripsModel> allTrips = [];
  List<TripsModel> filteredTrips = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

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
    final input = text.toLowerCase();
    final results = allTrips.where((trip) {
      final name = trip.name.toLowerCase();
      final location = trip.location.toLowerCase();
      final level = trip.difficulty.toLowerCase();
      final textMatch = name.contains(input) ||
          location.contains(input) ||
          level.contains(input);
      return textMatch;
    }).toList();

    setState(() {
      query = text;
      filteredTrips = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(color: Colors.black87),
              onChanged: searchTrips,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                filled: true,
                fillColor: Color(0xffEFE7DF),
                iconColor: Colors.brown,
                hintText: 'Search for trips...',
                prefixIcon: Icon(Icons.search, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.brown,
                    size: 20,
                  ),
                  onPressed: () {
                    if (searchController.text.isEmpty) {
                      Get.back();
                    } else {
                      searchController.clear();
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
            if (searchController.text.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Search Result of  ',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextSpan(
                        text: '" ${searchController.text} "',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TripCard(trip: filteredTrips[index]),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
