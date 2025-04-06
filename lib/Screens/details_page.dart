import 'dart:convert';
import 'dart:developer';
import 'package:adver_trail/component/date.dart';
import 'package:adver_trail/component/make_lines.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripDetailsPage extends StatefulWidget {
  final String title;
  final List<String> images;
  final String price;
  final String level;
  final String category;
  final String distance;
  final String accessibility;
  final String details;
  final String selectedDay;
  final String city;
  final double latitude;
  final double longitude;

  const TripDetailsPage({
    super.key,
    required this.title,
    required this.images,
    required this.price,
    required this.level,
    required this.category,
    required this.distance,
    required this.accessibility,
    required this.details,
    required this.selectedDay,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  @override
  TripDetailsPageState createState() => TripDetailsPageState();
}

class TripDetailsPageState extends State<TripDetailsPage> {
  String temperature = "";
  String windSpeed = "";
  int weatherCode = 0;
  String condition = "";
  String precipitationProbability = "";
  bool isLoading = true;
  int currentPage = 0;
 // bool isSaved = false;

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.latitude, widget.longitude);
  }

  // دالة لجلب الطقس من API
  Future<void> fetchWeather(double latitude, double longitude) async {
    const String apiKey = "dxr9X5imsMRRWh2RHMxeGA9sup4nXZmH";
    final url =
        "https://api.tomorrow.io/v4/timelines?location=$latitude,$longitude&fields=temperature,windSpeed,weatherCode,precipitationProbability&timesteps=current&units=metric&apikey=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature =
              "${data['data']['timelines'][0]['intervals'][0]['values']['temperature']}";
          windSpeed =
              "${data['data']['timelines'][0]['intervals'][0]['values']['windSpeed']} km/h";
          int weatherCode = data['data']['timelines'][0]['intervals'][0]
              ['values']['weatherCode'];
          condition = getWeatherDescription(weatherCode);
          precipitationProbability =
              "${data['data']['timelines'][0]['intervals'][0]['values']['precipitationProbability']}%";
          isLoading = false;
        });
      } else {
        print("API Error: ${response.statusCode}");
        log(response.statusCode.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Column(
        children: [
          // Stack لإضافة الصورة والأزرار فوقها
          Stack(
            children: [
              //Expanded
              // عرض الصورة
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      widget.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),

              // مؤشر النقاط (Page Indicator)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.brown
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // زر الرجوع
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // // زر الحفظ
              // Positioned(
              //   top: 40,
              //   right: 16,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         isSaved = !isSaved; // تغيير حالة الحفظ
              //       });
              //     },
              //     child: CircleAvatar(
              //       backgroundColor: Colors.white.withOpacity(0.8),
              //       child: Icon(
              //         isSaved
              //             ? Icons.bookmark // إذا محفوظة
              //             : Icons.bookmark_border, // إذا غير محفوظة
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الرحلة والسعر في نفس السطر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // اسم الرحلة
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // السعر
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown, // لون للسعر
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // مسافة بين الاسم والمستوى
                    // مستوى الصعوبة
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.level == 'Easy'
                                ? Colors.green.withOpacity(0.1)
                                : widget.level == 'Medium'
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.level,
                            style: TextStyle(
                              color: widget.level == 'Easy'
                                  ? Colors.green
                                  : widget.level == 'Moderate'
                                      ? Colors.orange
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.category == 'volunterring'
                                ? Colors.red.withOpacity(0.1)
                                : widget.category == 'cycling'
                                    ? Colors.orange
                                    : widget.category == 'Mountain trails'
                                        ? Colors.brown.withOpacity(0.1)
                                        : widget.category == 'water park'
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.category,
                            style: TextStyle(
                              color: widget.category == 'Volunteering'
                                  ? Colors.red
                                  : widget.category == 'Cycling'
                                      ? Colors.orange
                                      : widget.category == 'Mountain Trails'
                                          ? Colors.brown
                                          : widget.category == 'Water Parks'
                                              ? Colors.blue
                                              : Color(0xFFF9A825),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey, // لون الخط
                      thickness: 2, // سمك الخط
                      height: 20, // المسافة بين الخط والعناصر الأخرى
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 50),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/distance.png',
                                  width: 40, height: 40),
                            ),

                            const SizedBox(width: 80),
                            // Row(
                            //   children: [
                            //     const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/child.png',
                                  width: 40, height: 40),
                            ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Row(
                      children: [
                        const SizedBox(width: 50),
                        const Icon(Icons.circle,
                            size: 8, color: Color(0xFF3E2723)),
                        const SizedBox(width: 2),
                        Text(
                          widget.distance,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723)),
                        ),
                        // ],
                        //  ),
                        const SizedBox(width: 60),
                        Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 10, color: Color(0xFF3E2723)),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Text(
                                widget.accessibility,
                                style: const TextStyle(
                                    fontSize: 17, color: Color(0xFF3E2723)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Description',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.5),
                    ),

                    ReadMoreText(
                      text: widget.details,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "What's Included",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.5),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        // const SizedBox(width: 10),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/vehicles.png',
                                  width: 35, height: 35),
                            ),
                            Text(
                              'Transportation',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF3E2723)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/food.png',
                                  width: 35, height: 35),
                            ),
                            Text(
                              'Meals',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF3E2723)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/fee.png',
                                  width: 35, height: 35),
                            ),
                            Text(
                              'Entry Fees',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF3E2723)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFBDBDBD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset('assets/images/tour-guide.png',
                                  width: 35, height: 35),
                            ),
                            Text(
                              'Guided Tour',
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF3E2723)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.grey, // لون الخط
                      thickness: 2, // سمك الخط
                      height: 20, // المسافة بين الخط والعناصر الأخرى
                    ),
                    const SizedBox(height: 5),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    const Text(
                      'Trip Day:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    WeekDaysSelector(
                      selectedDay: widget.selectedDay, // حدد اليوم المطلوب
                    ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),

                    // فقرة الطقس
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   " ${widget.city.isNotEmpty ? widget.city : 'Unknown Location'}",
                              //   style: const TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.brown),
                              // ),
                              const SizedBox(height: 8),
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    temperature,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        getWeatherIconPath(weatherCode),
                                        width: 40,
                                        height: 40,
                                      ),
                                      // SizedBox(width: 8),
                                      Text(
                                        condition, // النص من getWeatherDescription
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )

                                  // Text(
                                  //   condition,
                                  //   style: const TextStyle(fontSize: 12),
                                  // ),
                                ],
                              ),
                              const SizedBox(width: 100),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.air,
                                          size: 15.0), // أيقونة الرياح
                                      Text(
                                        windSpeed,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.water_drop, // أيقونة قطرة الماء
                                        color: Colors.blue,
                                        size: 17,
                                      ),
                                      Text(
                                        precipitationProbability,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // الشريط الثابت في الأسفل
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          //color: Colors.white,
          color: Color(0xFFD9D9D9),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 5,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Book Now",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


String getWeatherDescription(int code) {
  switch (code) {
    case 0:
      return "Clear sky";
    case 1000:
      return "Clear";
    case 1100:
      return "Mostly clear";
    case 1101:
      return "Mostly Cloudy";
    case 1001:
      return "Cloudy";
    case 2100:
      return "Light Fog";
    case 4000:
      return "Drizzle";
    case 4001:
      return "Rain";
    case 4200:
      return "Light Rain";
    case 5000:
      return "Snow";
    default:
      return "Unknown";
  }
}

String getWeatherIconPath(int code) {
  switch (code) {
    case 0:
      return "assets/images/clear_small.png";
    case 1000:
      return "assets/images/clear_small.png";
    case 1100:
      return "assets/images/mostly_clear_small.png";
    case 1101:
      return "assets/images/mostly_cloudy_small.png";
    case 1001:
      return "assets/images/cloudy_small.png";
    case 2100:
      return "assets/images/fog_light_small.png";
    case 4000:
      return "assets/images/drizzle_small.png";
    case 4001:
      return "assets/images/rain_small.png";
    case 4200:
      return "assets/images/rain_light_mostly_clear_small.png";
    case 5000:
      return "assets/images/snow_small.png";
    default:
      return "assets/images/mostly_cloudy_small.png";
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class TripDetailsPage extends StatefulWidget {
//   final String title;
//   final List<String> images;
//   final String price;
//   final String level;
//   final String distance;
//   final String accessibility;
//   final String details;
//   final String city;
//   final double latitude;
//   final double longitude;
//
//   const TripDetailsPage({
//     super.key,
//     required this.title,
//     required this.images,
//     required this.price,
//     required this.level,
//     required this.distance,
//     required this.accessibility,
//     required this.details,
//     required this.city,
//     required this.latitude,
//     required this.longitude,
//   });
//
//   @override
//   TripDetailsPageState createState() => TripDetailsPageState();
// }
//
// class TripDetailsPageState extends State<TripDetailsPage> {
//   String temperature = "";
//   String windSpeed = "";
//   String weatherCode = "";
//   String condition = "";
//   String precipitationProbability = "";
//   bool isLoading = true;
//   int currentPage = 0;
//   bool isSaved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWeather(widget.latitude, widget.longitude);
//   }
//
//   // دالة لجلب الطقس من API
//   Future<void> fetchWeather(double latitude, double longitude) async {
//     const String apiKey = "dxr9X5imsMRRWh2RHMxeGA9sup4nXZmH";
//     final url =
//         "https://api.tomorrow.io/v4/timelines?location=$latitude,$longitude&fields=temperature,windSpeed,weatherCode,precipitationProbability&timesteps=current&units=metric&apikey=$apiKey";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           temperature =
//               "${data['data']['timelines'][0]['intervals'][0]['values']['temperature']}°C";
//           windSpeed =
//               "${data['data']['timelines'][0]['intervals'][0]['values']['windSpeed']} km/h";
//           int weatherCode = data['data']['timelines'][0]['intervals'][0]
//               ['values']['weatherCode'];
//           condition = getWeatherDescription(weatherCode);
//           precipitationProbability =
//               "${data['data']['timelines'][0]['intervals'][0]['values']['precipitationProbability']}%";
//           //temperature = "${data['main']['temp']}°C";
//           //condition = data['weather'][0]['description'];
//           isLoading = false;
//         });
//       } else {
//         log(response.statusCode.toString());
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error fetching weather: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFD9D9D9),
//       body: Column(
//         children: [
//           // Stack لإضافة الصورة والأزرار فوقها
//           Stack(
//             children: [
//               // عرض الصورة
//               SizedBox(
//                 height: 250,
//                 child: PageView.builder(
//                   itemCount: widget.images.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentPage = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return Image.asset(
//                       widget.images[index],
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     );
//                   },
//                 ),
//               ),
//
//               // مؤشر النقاط (Page Indicator)
//               Positioned(
//                 bottom: 10,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     widget.images.length,
//                     (index) => Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       width: currentPage == index ? 12 : 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: currentPage == index
//                             ? Colors.brown
//                             : Colors.grey.shade400,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // زر الرجوع
//               Positioned(
//                 top: 40,
//                 left: 16,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white.withOpacity(0.8),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               // زر الحفظ
//               Positioned(
//                 top: 40,
//                 right: 16,
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isSaved = !isSaved; // تغيير حالة الحفظ
//                     });
//                   },
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white.withOpacity(0.8),
//                     child: Icon(
//                       isSaved
//                           ? Icons.bookmark // إذا محفوظة
//                           : Icons.bookmark_border, // إذا غير محفوظة
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // اسم الرحلة والسعر في نفس السطر
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // اسم الرحلة
//                         Text(
//                           widget.title,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         // السعر
//                         Text(
//                           widget.price,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.brown, // لون للسعر
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8), // مسافة بين الاسم والمستوى
//                     // مستوى الصعوبة
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: widget.level == 'Easy'
//                             ? Colors.green.withOpacity(0.1)
//                             : widget.level == 'Medium'
//                                 ? Colors.orange.withOpacity(0.1)
//                                 : Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                         widget.level,
//                         style: TextStyle(
//                           color: widget.level == 'Easy'
//                               ? Colors.green
//                               : widget.level == 'Medium'
//                                   ? Colors.orange
//                                   : Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey, // لون الخط
//                       thickness: 2, // سمك الخط
//                       height: 20, // المسافة بين الخط والعناصر الأخرى
//                     ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     //Row(
//                       //children: [
//                         const SizedBox(width: 2),
//                          Text(
//                           widget.distance,
//                           style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                         ),
//                      // ],
//                   //  ),
//
//                     Row(
//                       children: [
//                         const Icon(Icons.circle, size: 10, color: Colors.black),
//                         const SizedBox(width: 4),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 1),
//                           child: Text(
//                           widget.accessibility ?? 'Not Specified',
//                           style: const TextStyle(
//                               fontSize: 16, color: Colors.black),
//                         ),
//                         ),
//                       ],
//                     ),
//                     ],
//                 ),
//                     Text(
//                       widget.details,
//                       style: const TextStyle(fontSize: 16, height: 1.5),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // فقرة الطقس
//                     isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 " ${widget.city.isNotEmpty ? widget.city : 'Unknown Location'}",
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.brown),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "Temperature: $temperature",
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               Text(
//                                 "Wind Speed: $windSpeed",
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               Text(
//                                 "Condition: $condition",
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.water_drop, // أيقونة قطرة الماء
//                                     color: Colors.blue,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     "$precipitationProbability",
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // الشريط الثابت في الأسفل
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           //color: Colors.white,
//           color: Color(0xFFD9D9D9),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               offset: Offset(0, -2),
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.brown,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: () {
//             print("Book Now Pressed");
//           },
//           child: const Text(
//             "Book Now",
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// String getWeatherDescription(int code) {
//   switch (code) {
//     case 0:
//       return "Clear sky";
//     case 1000:
//       return "Partly cloudy";
//     case 1100:
//       return "Mostly clear";
//     case 1101:
//       return "Partly cloudy";
//     case 2100:
//       return "Light rain";
//     case 4000:
//       return "Drizzle";
//     case 5001:
//       return "Flurries";
//     default:
//       return "Unknown weather condition";
//   }
// }
