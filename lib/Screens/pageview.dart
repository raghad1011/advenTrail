import 'dart:async';
import 'package:adver_trail/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class BoardingModel {
  final String image;
  final String title;
  final String description;

  BoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

int currentIndex = 0;
late PageController pageController;
Timer? timer;

next() {
  currentIndex++;
  pageController.animateToPage(currentIndex,
      duration: Duration(milliseconds: 500), curve: Curves.easeInCubic);
}

back() {
  currentIndex--;
  pageController.animateToPage(currentIndex,
      duration: Duration(milliseconds: 500), curve: Curves.easeInCubic);
}

void buildDot(int index) {
  currentIndex = index;
}

List<BoardingModel> boardingList = [
  BoardingModel(
    image: 'assets/images/WhatsApp Image 2025-01-03 at 11.19.49 PM.jpeg',
    title: 'Explore Jordan',
    description:
    'Venture into the unknown and uncover the secrets of nature.',
  ),
  BoardingModel(
    image: 'assets/images/talal.jpg',
    title: 'Prepare For The Adventure..',
    description: 'Get ready to make memories.',
  ),
  BoardingModel(
    image: 'assets/images/alsham (5).PNG',
    title: 'Start The Adventure!',
    description: 'Every step reveals new wonders and hidden beauty.',
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    pageController = PageController();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (currentIndex == boardingList.length - 1) {
        timer.cancel();
        Get.off(() => LoginScreen());
      } else {
        next();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              controller: pageController,
              itemCount: boardingList.length,
              onPageChanged: (value) {
                setState(() {
                  buildDot(value);
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                        boardingList[index].image,
                        fit: BoxFit.cover
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            boardingList[index].title,
                            style:  TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            boardingList[index].description,
                            style:  TextStyle(
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: boardingList.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 5,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: back,
                      icon: Icon( Icons.arrow_back,
                        color: Colors.white54,
                      ),
                      iconSize: 25,
                    ),

                    IconButton(
                      onPressed: currentIndex == boardingList.length - 1
                          ? () => Get.to(() => LoginScreen())
                          : next,
                      icon: Icon(
                        currentIndex == boardingList.length - 1
                            ? Icons.check_circle
                            : Icons.arrow_forward ,
                        color: Colors.white,
                      ),
                      iconSize: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
