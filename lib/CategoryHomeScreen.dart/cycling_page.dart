import 'package:flutter/material.dart';

class CyclingPage extends StatelessWidget {
  const CyclingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Cycling")),
      body:const Center(child: Text("Welcome to Cycling Page")),
    );
  }
}