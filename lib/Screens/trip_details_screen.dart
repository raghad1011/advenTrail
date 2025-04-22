import 'dart:convert';
import 'dart:developer';
import 'package:adver_trail/component/date.dart';
import 'package:adver_trail/component/make_lines.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../component/custom_bottom_nav_bar.dart';
import '../model/trips.dart';
import 'booking_screen.dart';
import 'home_screen.dart';

class TripDetailsPage extends StatefulWidget {
  final TripsModel trip;
  final String? id;

  const TripDetailsPage({super.key, required this.trip, this.id});

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
  late String dateFormatted;

  @override
  void initState() {
    super.initState();
    dateFormatted = widget.trip.tripDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.trip.tripDate!.toDate())
        : "Not set";
    fetchWeather(
        widget.trip.trailRoute.latitude, widget.trip.trailRoute.longitude);
  }

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
          Stack(
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: 1,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.trip.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              // مؤشر النقاط (Page Indicator)
              // Positioned(
              //   bottom: 10,
              //   left: 0,
              //   right: 0,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         width: 12,
              //         height: 8,
              //         decoration: BoxDecoration(
              //           color: Colors.brown,
              //           borderRadius: BorderRadius.circular(4),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // زر الرجوع
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Get.off(() => HomePage());
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
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.trip.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.trip.price.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.trip.difficulty == 'Easy'
                                ? Colors.green.withOpacity(0.1)
                                : widget.trip.difficulty == 'Medium'
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.trip.difficulty,
                            style: TextStyle(
                              color: widget.trip.difficulty == 'Easy'
                                  ? Colors.green
                                  : widget.trip.difficulty == 'Moderate'
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
                            color: widget.trip.category == 'volunterring'
                                ? Colors.red.withOpacity(0.1)
                                : widget.trip.category == 'cycling'
                                    ? Colors.orange
                                    : widget.trip.category == 'Mountain trails'
                                        ? Colors.brown.withOpacity(0.1)
                                        : widget.trip.category == 'water park'
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.yellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.trip.category,
                            style: TextStyle(
                              color: widget.trip.category == 'Volunteering'
                                  ? Colors.red
                                  : widget.trip.category == 'Cycling'
                                      ? Colors.orange
                                      : widget.trip.category ==
                                              'Mountain Trails'
                                          ? Colors.brown
                                          : widget.trip.category ==
                                                  'Water Parks'
                                              ? Colors.blue
                                              : Color(0xFFF9A825),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFBDBDBD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.asset('assets/images/distance.png',
                                    width: 40, height: 40),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFBDBDBD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.asset('assets/images/distance.png',
                                    width: 40, height: 40),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFBDBDBD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.asset('assets/images/child.png',
                                    width: 40, height: 40),
                              ),
                            ),
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
                          widget.trip.distance,
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
                                widget.trip.accessibility,
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
                      text: widget.trip.description.toString(),
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
                      selectedDay:
                          widget.trip.tripDate.toString(), // حدد اليوم المطلوب
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
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => BookingBottomSheet(trip: widget.trip,));
          },
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
