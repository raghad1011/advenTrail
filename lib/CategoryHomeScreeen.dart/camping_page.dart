import 'package:flutter/material.dart';
class CampingPage extends StatelessWidget {
  const CampingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camping")),
      body: const Center(child: Text("Welcome to Camping Page")),
    );
  }
}
