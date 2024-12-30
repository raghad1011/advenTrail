import 'package:flutter/material.dart';

class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'image': 'assets/images/image 6.png', 'label': 'Volunteering', 'route': '/volunteering'},
    {'image': 'assets/images/image.png', 'label': 'Cycling', 'route': '/cycling'},
    {'image': 'assets/images/image 4.png', 'label': 'Mountain trails', 'route': '/mountain_trails'},
    {'image': 'assets/images/image 10.png', 'label': 'Camping', 'route': '/camping'},
    {'image': 'assets/images/image 11.png', 'label': 'Water Parks', 'route': '/water_parks'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // الانتقال إلى صفحة جديدة بناءً على المسار
                Navigator.pushNamed(context, category['route']);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.brown[100],
                      borderRadius: BorderRadius.circular(12), // زوايا دائرية
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        category['image'],
                        width: 40, // عرض الصورة
                        height: 40,  // لضبط حجم الصورة
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
                      fontSize: 12,
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
