import 'package:flutter/material.dart';
import '../component/for_you_scroll.dart';
class WaterParksPage extends StatelessWidget {
  const WaterParksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Water Parks")),
        body: Container(child: const ForYouScroll(trips: [
          {'images': ['assets/images/hasa (1).PNG'], 'title': 'Wadi al-Hasa', 'price': '30 JD', 'details': 'This is Wadi al-Hasa.'},
          {'images': ['assets/images/karak (2).PNG'], 'title': 'Wadi Al-Karak', 'price': '40 JD', 'details': 'This is the Dead Sea.'},
          {'images': ['assets/images/mukhiris.PNG'], 'title': 'Wadi Mukhiris', 'price': '30 JD', 'details': 'This is Petra.'},


        ],),)
    );
  }
}