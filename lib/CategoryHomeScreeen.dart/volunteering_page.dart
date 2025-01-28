import 'package:adver_trail/component/for_you_scroll.dart';
import 'package:flutter/material.dart';
class VolunteeringPage extends StatelessWidget {
  const VolunteeringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Volunteering")),
      body: Container(child: const ForYouScroll(trips: [
  {
    'images': ['assets/images/um (1).JPG'],
    'title': 'Um Alnaml',}

      ],),),
    );
  }
}