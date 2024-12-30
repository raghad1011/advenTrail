import 'package:flutter/material.dart';

class MountainTrailsPage extends StatelessWidget {
  const MountainTrailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Mountain Trails")),
      body:const Center(child: Text("Welcome to Mountain Trails Page")),
    );
  }
}
