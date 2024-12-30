import 'package:flutter/material.dart';

class WaterParksPage extends StatelessWidget {
  const WaterParksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Water Parks")),
      body:const Center(child: Text("Welcome to Water Parks Page")),
    );
  }
}