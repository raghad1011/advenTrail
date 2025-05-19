import 'package:adver_trail/Screens/pageview.dart' as Get;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../component/trip_card.dart';
import '../model/trips.dart';
import '../network/firebase_services.dart';

class CategoryTripsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryTripsScreen({
    super.key,
    required this.categoryName,});

  @override
  State<CategoryTripsScreen> createState() => _CategoryTripsScreenState();
}

class _CategoryTripsScreenState extends State<CategoryTripsScreen> {
  TextEditingController searchController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  late Future<QuerySnapshot<TripsModel>> tripsFuture;

  @override
  void initState() {
    super.initState();
    tripsFuture = firebaseService.getAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    // final String? categoryLabel =
    //     ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            Text(widget.categoryName,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff361C0B),
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      body: FutureBuilder<QuerySnapshot<TripsModel>>(
        future: tripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No trips available.'));
          } else {
            final docs = snapshot.data!.docs;
            final trips = docs.map((doc) => doc.data()).toList();

            final categoryTrips = trips
                .where((trip) => trip.category == widget.categoryName)
                .toList();

            if (categoryTrips.isEmpty) {
              return Center(
                  child: Text(
                      'No trips found for ${widget.categoryName} category.'));
            }

            final filteredTrips = categoryTrips.where((trip) {
              final searchText = searchController.text.toLowerCase();
              return trip.name.toLowerCase().contains(searchText);
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.black87),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      filled: true,
                      fillColor: Color(0xffEFE7DF),
                      iconColor: Colors.brown,
                      hintText: 'Search your trip',
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          if (searchController.text.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Search Result of  ',
                                      style:
                                      TextStyle(color: Colors.grey, fontSize: 16),
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
                          ],
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredTrips.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: TripCard(trip: filteredTrips[index],),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
