// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class LocationPage extends StatelessWidget {
//   // رابط الموقع على Google Maps
//   final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=31.9539,35.9106";
//
//   const LocationPage({super.key}); // إحداثيات الموقع المطلوب
//
//   // دالة لفتح الرابط
//   Future<void> _openGoogleMaps() async {
//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       throw "تعذر فتح الرابط: $googleMapsUrl";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("تواصل معنا"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "نحن هنا لمساعدتك! يمكنك زيارة موقعنا على الخريطة عبر الزر أدناه.",
//               style: TextStyle(fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: _openGoogleMaps,
//               icon: Icon(Icons.location_on),
//               label: Text("افتح الموقع في Google Maps"),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 textStyle: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Location"),
      ),
      body:const Center(child: Text("Welcome to Location Page")),
    );
  }
}
