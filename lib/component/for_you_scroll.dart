import 'package:flutter/material.dart';
import '../Screens/details_page.dart'; // صفحة التفاصيل

class ForYouScroll extends StatefulWidget {
  final List<Map<String, dynamic>> trips;

  const ForYouScroll({
    super.key,
    required this.trips,
  });

  @override
  ForYouScrollState createState() => ForYouScrollState();
}

class ForYouScrollState extends State<ForYouScroll> {
  final Set<int> savedTrips = {}; // لمتابعة الرحلات المحفوظة

  void toggleSaveTrip(int index) {
    setState(() {
      if (savedTrips.contains(index)) {
        savedTrips.remove(index);
      } else {
        savedTrips.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true, // يسمح للـ GridView بأخذ حجمه من محتوياته
        itemCount: widget.trips.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final trip = widget.trips[index];
          final isSaved = savedTrips.contains(index);
          final imageUrl = (trip['images'] != null && trip['images'].isNotEmpty)
              ? trip['images'][0]
              : 'assets/images/default.jpg';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailsPage(
                    images: trip['images'] ?? 'assets/images/default.jpg',
                      title: trip['title'] ?? 'No Title',
                    price: trip['price'] ?? '',
                    level: trip['level'] ?? '',
                      distance :trip['distance'] ?? '0 km',
                      accessibility:trip['accessibility'] ?? '',
                    details: trip['details'] ?? 'No Details',
                    city: trip['city'] ?? 'unknown',
                    latitude: trip['latitude'],
                    longitude: trip['longitude']
                  ),
                ),
              );
            },
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imageUrl,
              height: 120,
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
                          trip['title'] ?? 'No Title',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (trip['price'] != null)
                          Text(
                            trip['price']!,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => toggleSaveTrip(index),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSaved ? Colors.brown[100] : Colors.brown[100],
                              ),
                              child: Icon(
                                Icons.bookmark,
                                size: 18,
                                color: isSaved ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
