// import 'package:flutter/material.dart';
//
// class OnBoarding extends StatefulWidget {
//   const OnBoarding({super.key});
//
//   @override
//   State<OnBoarding> createState() => _OnBoardingState();
// }
//
// class _OnBoardingState extends State<OnBoarding> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: [
//           Column(
//             children: [
//               Image.asset('assets/images/Ellipse 18.png'),
//               TextWidget(),
//               TextWidget(),
//               Row(
//                 children: [
//                   TextWidget(),
//                   Row(
//                     children: List.generate(
//                       3,
//                           (index) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         width: _currentPage == index ? 16 : 16,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: _currentPage == index
//                               ? const Color(0xFF4F331E)
//                               : const Color(0xFFB79489),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   TextWidget(),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:adver_trail/Screens/signup.dart';
import 'package:flutter/material.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  OnboardingPageViewState createState() => OnboardingPageViewState();
}

class OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              const OnboardingPage(
                imagePath: 'assets/images/Ellipse 18.png',
                title: 'Explore Jordan',
                description:
                    'Venture into the unknown\nand uncover the secrets of nature.',
              ),
              const OnboardingPage(
                imagePath: 'assets/images/imagebor2.png',
                title: 'Prepare For The Adventure..',
                description: 'Get ready to make memories.',
              ),
              OnboardingLastPage(
                imagePath: 'assets/images/Ellipsebor3.png',
                title: 'Start The Adventure!',
                description:
                    'Every step reveals new wonders and\nhidden beauty.',
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _currentPage != 2
                ? TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown[900],
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _currentPage != 2
                ? TextButton(
                    onPressed: _goToNextPage,
                    child: Text(
                      'Next',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown[900],
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 16 : 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF4F331E)
                        : const Color(0xFFB79489),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Positioned(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 80,
              left: 130,
              child: Image.asset('assets/images/Group 4.png',
                  width: 90, height: 90),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A2F1A)),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff4A2F1A),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingLastPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onButtonPressed;

  const OnboardingLastPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Positioned(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 80,
              left: 130,
              child: Image.asset('assets/images/Group 4.png',
                  width: 90, height: 90),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A2F1A)),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff4A2F1A),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F331E),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
