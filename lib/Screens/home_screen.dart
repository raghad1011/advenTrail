import 'package:adver_trail/Screens/search_page.dart';
import 'package:adver_trail/Screens/see_all_trips.dart';
import 'package:adver_trail/Screens/trip_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/category_scroll.dart';
import '../component/trip_card.dart';
import '../model/trips.dart';
import '../network/firebase_services.dart';
import 'appBar/notification.dart';
import 'filter.dart';
import 'appBar/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<TripsModel>> _tripsFuture;
  String username = 'Guest User';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tripsFuture = loadTrips();
    getUsername();
  }

  Future<List<TripsModel>> loadTrips() async {
    final snapshot = await _firebaseService.getAllTrips();
    final now = DateTime.now();

    return snapshot.docs.map((doc) => doc.data()).where((trip) {
      final tripDate = trip.tripDate?.toDate();
      if (tripDate == null) return false;
      return tripDate.isAfter(now) ||
          tripDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
    }).toList();
  }

  Future<void> getUsername() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          username = doc['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: username,
                  style: TextStyle(
                    color: Colors.brown[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon:
                  Icon(Icons.notifications_none, color: Colors.black, size: 28),
              onPressed: () {
                Get.to(() => NotificationScreen());
              },
            ),
            IconButton(
              icon:
                  Icon(Icons.person_2_outlined, color: Colors.black, size: 28),
              onPressed: () {
                Get.to(() => ProfilePage());
              },
            )
          ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Have a nice trip \non your great holiday !',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => SearchPage());
                    },
                    child: Container(
                      // width: Get.width/1.4,
                      // height: 30,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffD1C4B9),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xff361C0B),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Find your next adventure',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () => Get.to(() => FilterPage()),
                  child: Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Colors.brown[900]!,
                            Colors.brown[400]!,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(height: 10),
            CategoryScroll(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Explore Trips',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                GestureDetector(
                    onTap: () => Get.to(() => SeeAllTripsPage()),
                    child: Text('See All',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.brown))),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder<List<TripsModel>>(
              future: _tripsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No trips available'));
                }

                final trips = snapshot.data!;

                return SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => TripDetailsPage(trip: trip),
                              arguments: trip);
                        },
                        child: Container(
                          width: 170,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: TripCard(trip: trip),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
