import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor:const Color(0xffe6e6e6),
    
      body: Column(
      children: [
        Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/images/Ellipsebor3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 80,
            left: 150,
            child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
          ),]),

        const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 SizedBox(height: 25),
                 Text(
                  'Start The Adventure!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4f331e),
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 10),
                 Text(
                  'Every step reveals new wonders and\nhidden beauty.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff4f331e),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Color((0xff4F331E)),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color((0xffe6e6e6)),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff4F331E),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Color((0xff4F331E)),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color((0xffe6e6e6)),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 10,),
            SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.pushNamed(arguments: [],context, '/signup');

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

        const SizedBox(height: 10,),
              
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
          
        ],
      ),
    );
  }
}
