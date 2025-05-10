import 'dart:convert';
import 'dart:developer';
import 'package:adver_trail/Screens/rating.dart';
import 'package:adver_trail/component/date.dart';
import 'package:adver_trail/component/main_layout.dart';
import 'package:adver_trail/component/make_lines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/trips.dart';
import 'booking_screen.dart';

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

  double averageRating = 0.0;
  int ratingCount = 0;

  @override
  void initState() {
    super.initState();
    dateFormatted = widget.trip.tripDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.trip.tripDate!.toDate())
        : "Not set";
    fetchWeather(
        widget.trip.trailRoute.latitude, widget.trip.trailRoute.longitude);
    getRatingData();
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

  Future<void> getRatingData() async {
    final tripDoc = await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.trip.id)
        .get();

    if (tripDoc.exists) {
      final data = tripDoc.data();
      setState(() {
        averageRating = (data?['averageRating'] ?? 0).toDouble();
        ratingCount = (data?['ratingCount'] ?? 0).toInt();
      });
    }
  }

  void openRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        tripId: widget.trip.id,
        bookingId: 'dummy_booking_id',
      ),
    ).then((_) => getRatingData()); // بعد التقييم نعيد جلب البيانات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(widget.trip.imageUrl,
                  fit: BoxFit.cover, width: double.infinity, height: 200),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.trip.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.trip.category == 'Hiking'
                        ? Colors.red.withOpacity(0.1)
                        : widget.trip.category == 'Cycling'
                        ? Colors.orange
                        : widget.trip.category == 'Mountain'
                        ? Colors.brown.withOpacity(0.1)
                        : widget.trip.category == 'Water Activities'
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.yellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.trip.category,
                    style: TextStyle(
                      color: widget.trip.category == 'Hiking'
                          ? Colors.red
                          : widget.trip.category == 'Cycling'
                          ? Colors.orange
                          : widget.trip.category ==
                          'Mountain'
                          ? Colors.brown
                          : widget.trip.category ==
                          'Water Activities'
                          ? Colors.blue
                          : Color(0xFFF9A825),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Color(0xFF3E2723)),
                    Text(widget.trip.location,
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
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
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: openRatingDialog,
                        child: Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 24,
                              color: index < averageRating.round()
                                  ? Colors.amber
                                  : Colors.grey,
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "($ratingCount)", // عدد التقييمات
                        style: const TextStyle(fontSize: 14),
                      ),

                    ],
                  ),
                  Text("${widget.trip.price} JD",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Divider(),
            Text(
              'About',
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReadMoreText(text: widget.trip.description.toString(),),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.brown[800]),
                        Text("${widget.trip.duration} Hours"),
                      ],
                    ),
                    Text('Duration', style: TextStyle(color: Colors.black54))
                  ]),
                  Column(children: [
                    Row(
                      children: [
                        Icon(Icons.accessibility_new_outlined,
                            color: Colors.brown[800]),
                        Text("${widget.trip.accessibility}"),
                      ],
                    ),
                    Text('accessibility', style: TextStyle(color: Colors.black54))
                  ]),
                  Column(children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: Colors.brown[800]),
                        Text(widget.trip.distance),
                      ],
                    ),
                    Text("Distance",
                        style: TextStyle(color: Colors.black54))
                  ]),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ()async {
                      await launchUrl(Uri.parse(
                          'google.navigation:q=${widget.trip.trailRoute.latitude},${widget.trip.trailRoute.longitude}'));
                    },
                    child: Icon(Icons.map_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "What's Included",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.5),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.emoji_transportation,
                          size: 35,color: Colors.brown[800],),
                    ),
                    Text(
                      'Transportation',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.food_bank_outlined,
                          size: 35,color: Colors.brown[800],),
                    ),
                    Text(
                      'Meals',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.attach_money_outlined,
                          size: 35,color: Colors.brown[800],)
                    ),
                    Text(
                      'Entry Fees',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.tour_outlined,
                          size: 35,color: Colors.brown[800],)
                    ),
                    Text(
                      'Guided Tour',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.grey, // لون الخط
              thickness: 2, // سمك الخط
              height: 20, // المسافة بين الخط والعناصر الأخرى
            ),
            SizedBox(height: 5),
            Text(
              'Trip Day:',
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            WeekDaysSelector(
              selectedDay:
              widget.trip.tripDate.toString(), // حدد اليوم المطلوب
            ),
            SizedBox(height: 20),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.off(MainLayout()),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown, width: 2),
                ),
                child: Center(child: Icon(Icons.arrow_back, size: 24, color: Colors.brown),)
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(260, 50),
                  backgroundColor: Colors.brown[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
          ],
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