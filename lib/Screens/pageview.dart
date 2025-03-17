
import 'package:adver_trail/Screens/signup.dart';
import 'package:flutter/material.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

int currentIndex = 0;
late PageController pageController;

next() {
    currentIndex++;
    pageController.animateToPage(currentIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
  }
  void buildDot(int index) {
    currentIndex = index;
    
  }
  List<OnboardingPage> content = [
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
                OnboardingPage(
                  imagePath: 'assets/images/Ellipsebor3.png',
                  title: 'Start The Adventure!',
                  description:
                      'Every step reveals new wonders and\nhidden beauty.',
                 
                ),
  ];

  

class _OnboardingPageViewState extends State<OnboardingPageView> {
 @override
  void initState() {
     pageController = PageController();
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.74,
              width: MediaQuery.sizeOf(context).width,
              child: PageView.builder(
                  controller: pageController,
                  itemCount: content.length,
                  onPageChanged: (value) {
                    setState(() {
                      buildDot(value);
                    });
                    
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      children: [
                        Image(
                          image: AssetImage(content[i].imagePath),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          content[i].title,
                           style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xff4A2F1A),
                    fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          content[i].description,
                          style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff4A2F1A)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => 
                        
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          ),
                    child:  Text(
                      'skip',
                      style: TextStyle(
                              fontSize: 20,
                              color: Colors.brown[900],
                              fontWeight: FontWeight.bold),
                        ),
                    ),
                  
                  
                    Row(
                      children: List.generate(
                        content.length,
                        (index) => Container(
                          height: 10,
                          width:
                              currentIndex == index ? 25 : 10,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: currentIndex == index
                                ?const Color(0xFF4F331E)
                                : const Color(0xFFB79489),
                          ),
                        ),
                      ),
                    ),
                  
                 GestureDetector(
                      onTap: () => next(),
                      child: currentIndex ==
                              content.length - 1
                          ? GestureDetector(
                              onTap: () =>
                                   Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          ),
                              child:  Text('Continue',style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown[900],
                          fontWeight: FontWeight.bold),
                    ),
                            )
                          :  Text('Next',style: TextStyle(
                          fontSize: 20,
                          color: Colors.brown[900],
                          fontWeight: FontWeight.bold),),
                    ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class OnboardingPage  {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    
    required this.imagePath,
    required this.title,
    required this.description,
});
}