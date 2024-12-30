import 'package:flutter/material.dart';
import '../component/verify_text_field.dart';


class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  VerifyScreenState createState() => VerifyScreenState();
}

class VerifyScreenState extends State<VerifyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Colors.transparent,
   elevation: 0,  
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff4f331e),size:32,),
          onPressed: () {
            Navigator.pop((context),'/login'); // العودة إلى الصفحة السابقة
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Positioned(
                top: 80,
                left: 150,
                child: Image.asset('assets/images/Group 4.png', width: 90, height: 90),
              ),
              const SizedBox(height: 20),

              const Text(
                "Email Verify",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff361C0B),
                ),
              ),
              const SizedBox(height: 30,),
              
              const Text(
                "Code is sent to email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10,),
              const Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
              CustomTextFieldsRow(), 
              CustomTextFieldsRow(),
              CustomTextFieldsRow(),
              CustomTextFieldsRow(),
               ],),
              const SizedBox(height: 30,),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5,),
              RichText(
text: TextSpan(
    children: [
      const TextSpan(
        text: "Don’t recieve code?",
        style: TextStyle(
          color: Color(0xffD1C4B9),
          fontSize: 14,
        ),
      ),
      WidgetSpan(
        child: GestureDetector(
          onTap: () {
            // هنا التنقل إلى صفحة "نسيت كلمة المرور"
            Navigator.pushNamed(context, '/forgot-password');
          },
          child: const Text(
            '  Resend again',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  ),
),
 
 
              
              
              ],
          ),),),);
  }} 