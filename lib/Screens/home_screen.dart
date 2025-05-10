import 'package:adver_trail/Screens/bottomBar/map_screen.dart';
import 'package:adver_trail/Screens/search_page.dart';
import 'package:adver_trail/Screens/trip_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/category_scroll.dart';
import '../model/trips.dart';
import '../network/firebase_services.dart';
import 'filter.dart';
import 'profile_screen.dart';

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
    return snapshot.docs.map((doc) => doc.data()).toList();
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
                    color: Colors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                  Icons.notifications_none, color: Colors.black, size: 28),
              onPressed: () {
                Get.to(() =>  LocationPage());
              },
            ),
            IconButton(
              icon: Icon(
                  Icons.person_2_outlined, color: Colors.black, size: 28),
              onPressed: () {
                Get.to(() =>  ProfilePage());
              },
            )
          ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Have a nice trip \non your great holiday !',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffD1C4B9),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.brown,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Find your next adventure...',style: TextStyle(
                            color: Colors.black54,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () => Get.to(() => FilterPage()),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.brown,
                      ),
                      child: Icon(Icons.filter_alt_outlined ,color: Colors.white,)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Categories', style: TextStyle(fontWeight: FontWeight.bold,),),
            SizedBox(height: 10),
            CategoryScroll(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Popular Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all trips', style: TextStyle(color: Colors.brown)),
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
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => TripDetailsPage(trip: trip),
                              arguments: trip);
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  trip.imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text('${trip.price} JD',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                            ],
                          ),
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