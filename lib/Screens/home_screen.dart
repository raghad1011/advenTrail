import 'package:adver_trail/Screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottomBar/location_screen.dart';
import '../bottomBar/profile_screen.dart';
import '../component/category_scroll.dart';
import '../model/trips.dart';
import '../network/firebase_services.dart';
import 'trip_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<TripsModel>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = loadTrips();
  }

  Future<List<TripsModel>> loadTrips() async {
    final snapshot = await _firebaseService.getAllTrips();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6E6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchPage(),
                    ),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  hintText: 'Find your next adventure...',
                  filled: true,
                  fillColor: const Color(0xffD1C4B9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xff361C0B),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/Frame 40.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  right: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/point');
                    },
                    child: Image.asset(
                      'assets/images/gift.png',
                      width: 30,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: CategoryScroll(),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const SizedBox(width: 15),
              const Text(
                'Trips For You',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // IconButton(
              //   icon: const Icon(
              //     Icons.filter_alt,
              //     color: Colors.black,
              //     size: 32,
              //   ),
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/filter');
              //   },
              // ),
            ],
          ),
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
             return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: trips.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => TripDetailsPage(trip: trip,), arguments: trip);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Image.network(
                                    trip.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text("Image not found"),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.name,
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trip.price.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffE6E6E6),
        currentIndex: 0,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 32),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 32),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Get.to(() => const LocationPage());
          } else if (index == 2) {
            Get.to(() => const ProfilePage());
          }
        },
      ),
    );
  }
}
