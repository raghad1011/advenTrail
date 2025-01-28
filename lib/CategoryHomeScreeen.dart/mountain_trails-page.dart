import 'package:flutter/material.dart';
import '../component/for_you_scroll.dart';
class MountainTrailsPage extends StatelessWidget {
  const MountainTrailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mountain Trails")),
      body: const Column(
        children: [
          Expanded(
            child: ForYouScroll(
              trips: [
                {'images': ['assets/images/alsham (2).PNG'], 'title': 'Wadi Alsham', 'price': '28 JD'},
                {'images': ['assets/images/qais (3).JPG'], 'title': 'Um Qais', 'price': '25 JD'},
              ],
            ),
          ),
        ],
      ),
    );
  }
}