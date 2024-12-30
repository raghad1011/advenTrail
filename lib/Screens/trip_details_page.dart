import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripDetailsApp extends StatelessWidget {
  const TripDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Trip Details',
      home: TripDetailsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TripDetailsPage extends StatefulWidget {
  const TripDetailsPage({super.key});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final List<String> imageUrls = [
    'assets/images/enaba1.jpg',
    'assets/images/enaba2.jpg',
  ];

  int currentPage = 0;
  String temperature = "";
  String condition = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather("Amman"); // اسم المدينة
  }

  // دالة لجلب الطقس من API
  Future<void> fetchWeather(String city) async {
    const String apiKey = "e4df8c9f7349a1cf3d8647eeaf44d424";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = "${data['main']['temp']}°C";
          condition = data['weather'][0]['description'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Stack لإضافة الصورة والأزرار فوقها
          Stack(
            children: [
              // PageView الخاص بالصور
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // زر الرجوع (السهم)
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child:const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // زر الحفظ (السيف)
              Positioned(
                top: 40,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    print("Saved!");
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child:const Icon(
                      Icons.bookmark_border,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // النقاط (Indicators)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                        (index) => Container(
                      margin:const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.white
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // باقي محتوى الصفحة
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enaba forest path",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Medium, Mountain trails",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Located in northern Jordan. It is one of the dense forests full of oak, sycamore, oak, hawthorn, and sycamore trees."
                          "\n\nThe trail features shaded walks throughout the trail, and the trail ends with a view called Iraq Al-Tabl, and Iraq means hills."
                          "\n\nThe walk is one-way and will take you to the rest area and the bus."
                          "\n\nThe trail is very special, and it is one of the most important landmarks of adventure tourism in Jordan.",
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),

                    // فقرة الطقس
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Current Weather in Amman",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Temperature: $temperature",
                          style:const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Condition: $condition",
                          style:const TextStyle(fontSize: 16),
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
    );
  }
}
