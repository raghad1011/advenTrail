import 'package:adver_trail/Screens/category_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'image': 'assets/images/cycle.jpeg', 'label': 'Nature Trail', 'route': '/Nature Trail'},
    {'image': 'assets/images/mountain.jpeg', 'label': 'Mountain', 'route': '/Mountain'},
    {'image': 'assets/images/hiking.jpeg', 'label': 'Hiking', 'route': '/hiking'},
    {'image': 'assets/images/camping.jpeg', 'label': 'Camping', 'route': '/camping'},
    {'image': 'assets/images/water Activities.jpeg', 'label': 'Water Activities', 'route': '/water_Activities'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              Get.to (() => CategoryTripsScreen(categoryName: category['label']),);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        category['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 30, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['label'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
